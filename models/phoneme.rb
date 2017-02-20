# frozen_string_literal: true
class Phoneme
  attr_reader :phoneme, :scalar, :octave_offset

  SCALAR_BASE = 1.0
  OCTAVE_OFFSET = 3
  DURATION_BASE = 3_000.0

  def initialize(phoneme)
    @phoneme =
      case phoneme
      when 'N/A'
        :UNAVAILABLE
      when ' '
        :PAUSE
      else
        phoneme.to_s.upcase.gsub(/[^a-z ]/i, '').to_sym
      end
  end

  def duration
    (Phonemes.get(phoneme)[:duration] / DURATION_BASE) * (scalar || SCALAR_BASE)
  end

  def index
    Phonemes.collection.keys.index(phoneme)
  end

  def octave
    ((index + 1) / (Phonemes.length / Phonemes.octaves)).ceil + (octave_offset || OCTAVE_OFFSET)
  end

  def latin
    Phonemes.notes[index % Phonemes.notes.length].to_s + octave.to_s
  end

  def note
    @note ||= Note.from_latin(latin)
  end

  def frequency
    note.frequency
  end

  def scale(scalar)
    @scalar = scalar
  end

  def pitch(octave_offset)
    @octave_offset = octave_offset
  end

  def to_json(*)
    {
      phoneme: phoneme,
      index: index,
      duration: duration
    }.to_json
  end
end
