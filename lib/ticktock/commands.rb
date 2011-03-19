module Commands
  def tick
    # Do stuff here
  end

  def install
    create_directory unless File.exists? DB_DIR
    create_db unless File.exists? "#{DB_DIR}/#{DB_NAME}.db"
  end

  def categories
    @db[:categories]
  end
  private

  def create_directory
    FileUtils.mkdir(DB_DIR, :mode => 0755)
  end

  def create_db
    @db.create_table :categories do
      primary_key :id
      String :name, :unique => true, :null => false
    end

    @db.create_table :times do
      primary_key :id
      foreign_key :category_id, :categories
      DateTime :start_at, :null => false
      DateTime :end_at
    end

    @db[:categories].insert(:name => 'misc')
  end
end
