class Phonemes
  class << self
    def duration(phoneme)
      self.collection[phoneme][:duration]
    end

    def index(key)
      self.collection.keys.index(key)
    end

    def collection
      {
        aa: {
          duration: 217
        },
        ae: {
          duration: 286
        },
        ah: {
          duration: 328
        },
        ao: {
          duration: 463
        },
        aw: {
          duration: 456
        },
        ax: {
          duration: 456
        },
        ay: {
          duration: 300
        },
        b: {
          duration: 17
        },
        ch: {
          duration: 126
        },
        d: {
          duration: 47
        },
        dh: {
          duration: 168
        },
        eh: {
          duration: 193
        },
        er: {
          duration: 420
        },
        ey: {
          duration: 288
        },
        f: {
          duration: 93
        },
        g: {
          duration: 93
        },
        hh: {
          duration: 171
        },
        ih: {
          duration: 286
        },
        iy: {
          duration: 158
        },
        jh: {
          duration: 138
        },
        k: {
          duration: 93
        },
        l: {
          duration: 328
        },
        m: {
          duration: 185
        },
        n: {
          duration: 316
        },
        ng: {
          duration: 207
        },
        ow: {
          duration: 417
        },
        oy: {
          duration: 578
        },
        p: {
          duration: 94
        },
        r: {
          duration: 132
        },
        s: {
          duration: 298
        },
        sh: {
          duration: 308
        },
        t: {
          duration: 76
        },
        th: {
          duration: 256
        },
        uh: {
          duration: 315
        },
        uw: {
          duration: 434
        },
        v: {
          duration: 287
        },
        w: {
          duration: 330
        },
        wh: {
          duration: 352
        },
        y: {
          duration: 300
        },
        yu: {
          duration: 208
        },
        z: {
          duration: 320
        },
        zh: {
          duration: 192
        }
      }
    end
  end
end
