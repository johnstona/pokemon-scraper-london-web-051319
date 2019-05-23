class Pokemon

    attr_accessor :name, :type, :db, :id, :hp


    def initialize(name:, type:, id:, hp: nil, db:)
        @name = name
        @type = type
        @id = id
        @hp = hp
        @db = db
    end
    
    def self.save(name, type, db)

        sql = <<-SQL
          INSERT INTO pokemon (name, type)
          VALUES (?, ?)
        SQL
        db.execute(sql, name, type)
    
        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]

      end

      def self.new_from_db(row, db)
        new_pokemon = self.new(id: row[0], name: row[1], type: row[2], hp: row[3], db: db)
        new_pokemon
      end

      def self.find(id, db)
        sql = <<-SQL
            SELECT *
            FROM pokemon
            WHERE id = ?
            SQL

        db.execute(sql, id).map {|row| self.new_from_db(row, db)}.first
      end

      def alter_hp(num, db)
        sql = <<-SQL
            UPDATE pokemon
            SET hp = ?
            WHERE id = ?
            SQL
        
        db.execute(sql, num, self.id)

      end

end
