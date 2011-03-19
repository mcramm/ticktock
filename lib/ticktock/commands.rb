module Commands
  def tick(name = 'misc')
    category = get_category name
    category = create_category(name) if category.nil?

    @db[:times].insert(:start_at => Time.now.to_i, :category_id => category[:id])
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

    create_category
  end

  def create_category(name = 'misc')
    @db[:categories].insert(:name => name)

    get_category name
  end

  def get_category(name = 'misc')
    @db[:categories].where(:name => name).first
  end

  def connect_to_db
    Sequel.sqlite "#{DB_DIR}/#{DB_NAME}.db"
  end
end
