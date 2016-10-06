class Phonemes
  class << self
    def get(phoneme)
      self.collection[phoneme] || {}
    end

    def collection
      {
        AA: {
          duration: 217
        },
        AE: {
          duration: 286
        },
        AH: {
          duration: 328
        },
        AO: {
          duration: 463
        },
        AW: {
          duration: 456
        },
        AX: {
          duration: 456
        },
        AY: {
          duration: 300
        },
        B: {
          duration: 75
        },
        CH: {
          duration: 126
        },
        D: {
          duration: 75
        },
        DH: {
          duration: 168
        },
        EH: {
          duration: 193
        },
        ER: {
          duration: 420
        },
        EY: {
          duration: 288
        },
        F: {
          duration: 93
        },
        G: {
          duration: 93
        },
        HH: {
          duration: 171
        },
        IH: {
          duration: 286
        },
        IY: {
          duration: 158
        },
        JH: {
          duration: 138
        },
        K: {
          duration: 93
        },
        L: {
          duration: 328
        },
        M: {
          duration: 185
        },
        N: {
          duration: 316
        },
        NG: {
          duration: 207
        },
        OW: {
          duration: 417
        },
        OY: {
          duration: 578
        },
        P: {
          duration: 94
        },
        R: {
          duration: 132
        },
        S: {
          duration: 298
        },
        SH: {
          duration: 308
        },
        T: {
          duration: 76
        },
        TH: {
          duration: 256
        },
        UH: {
          duration: 315
        },
        UW: {
          duration: 434
        },
        V: {
          duration: 287
        },
        W: {
          duration: 330
        },
        WH: {
          duration: 352
        },
        Y: {
          duration: 300
        },
        YU: {
          duration: 208
        },
        Z: {
          duration: 320
        },
        ZH: {
          duration: 192
        },
        PAUSE: {
          duration: 1_000
        },
        UNAVAILABLE: {
          duration: 2_000
        }
      }
    end
  end
end
