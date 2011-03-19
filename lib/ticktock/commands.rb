module Commands
  def tick(name = 'misc')
    category = get_category name
    category = create_category(name) if category.nil?

    @db[:times].insert(:start_at => Time.now.to_i, :category_id => category[:id])
  end

  def tock(name = nil)
    times = @db[:times].where(:end_at => nil)

    unless name.nil?
      category_id = @db[:categories].where(:name => name).first[:id]
      times = times.where(:category_id => category_id)
    end

    unended_times = times.order(:id).all

    if unended_times.size == 0
      name.nil? ? tick : tick(name)
    else
      times.where(:id => unended_times.last[:id]).update(:end_at => Time.now.to_i)
    end
  end

  def report
    categories = @db[:categories].order(:id).all
    result_string = "Here is a quick summary for all of your logged times:\n\n"

    results = Hash.new
    categories.each do |category|
      category_times = @db[:times].where(:category_id => category[:id]).all
      seconds = 0

      category_times.each do |time|
        seconds += time[:end_at] - time[:start_at]
      end

      hours = sprintf("%.1f", (seconds.to_f/3600.to_f))

      results[category[:name]] = {:hours => hours, :seconds => seconds}
      result_string << "\t#{category[:name]}: #{hours} hrs. (#{seconds} sec)\n"
    end

    return result_string
    # do stuff
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
