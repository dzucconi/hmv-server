require 'json'
require 'byebug'
require 'optparse'
require 'securerandom'
require 'digest/sha1'
require 'wavefile'
require 'oj'
require 'typhoeus'

require_relative './config/initializers/object'
require_relative './config/initializers/hash'
require_relative './lib/corrasable'
require_relative './lib/output'
require_relative './lib/synthetic'
require_relative './lib/wave'
require_relative './lib/phonemes'

FPS = 29.97

timeline = [
  { word: "I", start: "11:25", end: "12:10" },
  { word: "WANT", start: "12:11", end: "13:00" },
  { word: "SOME", start: "13:01", end: "13:18" },
  { word: "RED", start: "13:19", end: "15:12" },
  { word: "ROSES", start: "15:13", end: "17:21" },
  { word: "FOR", start: "18:26", end: "19:14" },
  { word: "A", start: "19:15", end: "19:23" },
  { word: "BLUE", start: "19:25", end: "21:04" },
  { word: "LADY", start: "21:10", end: "23:14" },
  { word: "MISTER", start: "25:17", end: "26:06" },
  { word: "FLORIST", start: "26:07", end: "27:11" },
  { word: "TAKE", start: "27:12", end: "27:26" },
  { word: "MY", start: "27:27", end: "28:15" },
  { word: "ORDER", start: "28:16", end: "29:04" },
  { word: "PLEASE", start: "29:07", end: "33:15" },
  { word: "WE", start: "34:29", end: "35:22" },
  { word: "HAD", start: "36:01", end: "36:18" },
  { word: "A", start: "36:19", end: "37:06" },
  { word: "SILLY", start: "37:10", end: "38:00" },
  { word: "QUARREL", start: "38:01", end: "39:22" },
  { word: "THE", start: "42:09", end: "42:16" },
  { word: "OTHER", start: "42:17", end: "42:27" },
  { word: "DAY", start: "42:28", end: "45:20" },
  { word: "HOPE", start: "46:07", end: "46:19" },
  { word: "THESE", start: "46:20", end: "47:12" },
  { word: "PRETTY", start: "47:16", end: "47:21" },
  { word: "FLOWERS", start: "47:25", end: "49:03" },
  { word: "CHASE", start: "49:10", end: "49:23" },
  { word: "HER", start: "49:24", end: "49:29" },
  { word: "BLUES", start: "50:00", end: "51:28" },
  { word: "AWAY", start: "52:00", end: "53:09" },
  { word: "I", start: "53:13", end: "53:18" },
  { word: "WANT", start: "53:25", end: "54:19" },
  { word: "SOME", start: "54:19", end: "54:25" },
  { word: "RED", start: "54:26", end: "56:11" },
  { word: "ROSES", start: "57:10", end: "58:18" },
  { word: "FOR", start: "58:21", end: "59:12" },
  { word: "A", start: "59:19", end: "59:25" },
  { word: "BLUE", start: "59:27", end: "61:07" },
  { word: "LADY", start: "62:15", end: "64:18" },
  { word: "SEND", start: "65:17", end: "66:03" },
  { word: "THEM", start: "66:04", end: "66:10" },
  { word: "TO", start: "66:15", end: "66:21" },
  { word: "THE", start: "66:24", end: "67:04" },
  { word: "SWEETEST", start: "67:07", end: "68:14" },
  { word: "GAL", start: "68:20", end: "69:15" },
  { word: "IN", start: "69:17", end: "69:20" },
  { word: "TOWN", start: "69:21", end: "71:29" },
  { word: "AND", start: "74:09", end: "74:28" },
  { word: "IF", start: "74:29", end: "75:05" },
  { word: "THEY", start: "75:08", end: "75:24" },
  { word: "DO", start: "76:10", end: "76:18" },
  { word: "THE", start: "76:19", end: "76:22" },
  { word: "TRICK,", start: "76:26", end: "77:15" },
  { word: "I’LL", start: "79:00", end: "80:02" },
  { word: "HURRY", start: "80:04", end: "80:14" },
  { word: "HOME", start: "80:15", end: "81:14" },
  { word: "TO", start: "81:15", end: "81:20" },
  { word: "PICK", start: "81:21", end: "82:16" },
  { word: "YOUR", start: "83:19", end: "84:00" },
  { word: "BEST", start: "84:01", end: "84:14" },
  { word: "WHITE", start: "84:17", end: "84:29" },
  { word: "ORCHID", start: "85:05", end: "85:22" },
  { word: "FOR", start: "86:21", end: "87:03" },
  { word: "HER", start: "87:04", end: "87:09" },
  { word: "WEDDING", start: "87:14", end: "88:15" },
  { word: "GOWN", start: "88:17", end: "91:12" },
  { word: "WANT", start: "92:15", end: "93:07" },
  { word: "SOME", start: "93:08", end: "93:12" },
  { word: "RED", start: "93:15", end: "94:07" },
  { word: "ROSES", start: "95:21", end: "97:09" },
  { word: "FOR", start: "97:11", end: "97:20" },
  { word: "A", start: "97:21", end: "97:29" },
  { word: "BLUE", start: "98:02", end: "98:23" },
  { word: "BLUE", start: "100:03", end: "100:10" },
  { word: "LADY", start: "100:12", end: "101:16" },
  { word: "MISTER", start: "103:01", end: "103:25" },
  { word: "FLORIST", start: "103:26", end: "104:16" },
  { word: "TAKE", start: "104:20", end: "105:17" },
  { word: "MY", start: "105:20", end: "106:10" },
  { word: "ORDER", start: "106:15", end: "106:24" },
  { word: "PLEASE", start: "106:26", end: "108:19" },
  { word: "HAD", start: "111:26", end: "112:14" },
  { word: "A", start: "112:15", end: "112:17" },
  { word: "SILLY", start: "112:22", end: "113:08" },
  { word: "QUARREL", start: "113:10", end: "114:07" },
  { word: "JUST", start: "116:07", end: "116:28" },
  { word: "THE", start: "116:29", end: "117:04" },
  { word: "OTHER", start: "117:05", end: "117:10" },
  { word: "DAY", start: "117:11", end: "118:27" },
  { word: "HOPE", start: "121:09", end: "121:21" },
  { word: "THESE", start: "121:22", end: "121:28" },
  { word: "PRETTY", start: "122:00", end: "122:10" },
  { word: "FLOWERS", start: "122:11", end: "123:01" },
  { word: "CHASE", start: "123:02", end: "123:25" },
  { word: "HER", start: "124:03", end: "124:05" },
  { word: "BLUES", start: "124:06", end: "127:06" },
  { word: "AWAY", start: "127:07", end: "128:23" },
  { word: "WANT", start: "128:27", end: "129:12" },
  { word: "SOME", start: "129:15", end: "129:18" },
  { word: "RED", start: "129:19", end: "131:22" },
  { word: "ROSES", start: "131:24", end: "133:00" },
  { word: "FOR", start: "133:20", end: "133:26" },
  { word: "A", start: "133:27", end: "134:00" },
  { word: "BLUE,", start: "134:06", end: "134:21" },
  { word: "BLUE", start: "135:25", end: "136:09" },
  { word: "LADY", start: "136:11", end: "137:07" },
  { word: "SEND", start: "139:16", end: "139:22" },
  { word: "THEM", start: "139:25", end: "140:01" },
  { word: "TO", start: "140:05", end: "140:12" },
  { word: "THE", start: "140:14", end: "140:22" },
  { word: "SWEETEST", start: "140:25", end: "141:19" },
  { word: "GAL", start: "141:22", end: "142:18" },
  { word: "IN", start: "142:20", end: "142:27" },
  { word: "TOWN", start: "142:28", end: "144:10" },
  { word: "AND", start: "147:12", end: "147:27" },
  { word: "IF", start: "147:29", end: "148:08" },
  { word: "THEY", start: "148:11", end: "148:22" },
  { word: "JUST", start: "148:23", end: "149:04" },
  { word: "DO", start: "149:05", end: "149:09" },
  { word: "THAT", start: "149:10", end: "149:17" },
  { word: "TRICK,", start: "149:18", end: "150:05" },
  { word: "I’M", start: "151:12", end: "151:23" },
  { word: "GONNA", start: "151:24", end: "152:06" },
  { word: "HURRY", start: "152:07", end: "153:18" },
  { word: "BACK", start: "153:18", end: "153:29" },
  { word: "AND", start: "154:00", end: "154:06" },
  { word: "PICK", start: "154:12", end: "155:05" },
  { word: "CA", start: "155:08", end: "155:19" },
  { word: "YOUR", start: "156:12", end: "156:19" },
  { word: "BEST", start: "156:20", end: "157:07" },
  { word: "WHITE", start: "157:13", end: "157:26" },
  { word: "ORCHID", start: "157:27", end: "158:18" },
  { word: "FOR", start: "158:21", end: "159:14" },
  { word: "HER", start: "159:16", end: "159:25" },
  { word: "WEDDING", start: "159:26", end: "160:26" },
  { word: "GOWN", start: "161:02", end: "163:28" },
  { word: "I’LL", start: "165:02", end: "166:03" },
  { word: "PICK", start: "166:07", end: "166:18" },
  { word: "YOUR", start: "166:19", end: "166:26" },
  { word: "BEST", start: "166:27", end: "167:11" },
  { word: "WHITE", start: "167:13", end: "167:27" },
  { word: "ORCHID", start: "167:29", end: "169:01" },
  { word: "FOR", start: "169:02", end: "169:21" },
  { word: "HER", start: "170:09", end: "171:22" },
  { word: "WEDDING", start: "171:23", end: "172:09" },
  { word: "GOWN", start: "172:11", end: "176:14" }
]

def time_at(string)
  seconds, frames = string.split ':'
  seconds.to_f + (frames.to_f / FPS)
end

synth = Synthetic.new

filenames = timeline.map.with_index do |opts, i|
  p opts[:word]

  if i === 0
    pause = Wave.buffer_to_file(synth.speak(:pause, time_at(opts[:start])))
  else
    pause = Wave.buffer_to_file(synth.speak(:pause, (time_at(opts[:start]) - (time_at(timeline[i - 1][:end])))))
  end

  duration = time_at(opts[:end]) - time_at(opts[:start])

  output = Output.new({
    text: opts[:word],
    duration: duration,
    filename: Digest::SHA1.hexdigest([opts[:word], duration].compact.join('_'))
  })

  output.generate! if output

  [pause, output&.filename].compact
end.flatten

p Wave.concat_files(filenames, Synthetic::SAMPLE_RATE, 'red-roses-output')

File.write 'tmp/red-roses-output.json', timeline.map { |opts|
  { word: opts[:word], start: time_at(opts[:start]), end: time_at(opts[:end]) }
}.to_json
