class Song

    @@all = []

    attr_accessor :name, :artist, :genre

    def initialize(name, artist = nil, genre = nil)
        self.name = name
        self.artist = artist if artist
        self.genre = genre if genre
    end

    def artist=(artist)
        @artist = artist
        artist.add_song(self) #if artist
    end

    def genre=(genre)
        @genre = genre
        genre.songs << self unless genre.songs.include?(self)
    end

    def self.find_by_name(name)
        self.all.find{|song| song.name == name}
    end

    def self.find_or_create_by_name(name)
        find_by_name(name) || create(name)
    end

    def self.new_from_filename(file)
        artist, song, genre = file.sub(/\.mp3/, "").split(" - ")
        new_song = Song.new(song) || find_by_name(song)
        new_song.artist = Artist.find_or_create_by_name(artist)
        new_song.genre = Genre.find_or_create_by_name(genre)
        new_song
    end

    def self.create_from_filename(name)
        new_from_filename(name).save
    end
    #TODO All of this should be modularized
    def self.all
        @@all
    end

    def self.destroy_all
        all.clear
    end

    def self.create(name)
        song = Song.new(name)
        song.save
        song
    end
    def save
        self.class.all << self
    end
end
