class ScrumflowRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :scrumflow

  before_save :raise_readonly_record
  before_destroy :raise_readonly_record

  class << self
    def create(...)
      raise_readonly_record
    end

    def create!(...)
      raise_readonly_record
    end

    def update(...)
      raise_readonly_record
    end

    def update_all(...)
      raise_readonly_record
    end

    def delete(...)
      raise_readonly_record
    end

    def delete_all(...)
      raise_readonly_record
    end

    def destroy(...)
      raise_readonly_record
    end

    def destroy_all(...)
      raise_readonly_record
    end

    def insert(...)
      raise_readonly_record
    end

    def insert!(...)
      raise_readonly_record
    end

    def insert_all(...)
      raise_readonly_record
    end

    def insert_all!(...)
      raise_readonly_record
    end

    def upsert(...)
      raise_readonly_record
    end

    def upsert_all(...)
      raise_readonly_record
    end

    private

    def raise_readonly_record
      raise ActiveRecord::ReadOnlyRecord, "#{name} is connected to the Scrumflow database in read-only mode"
    end
  end

  def readonly?
    true
  end

  def save(...)
    raise_readonly_record
  end

  def save!(...)
    raise_readonly_record
  end

  def update(...)
    raise_readonly_record
  end

  def update!(...)
    raise_readonly_record
  end

  def update_attribute(...)
    raise_readonly_record
  end

  def update_attribute!(...)
    raise_readonly_record
  end

  def update_column(...)
    raise_readonly_record
  end

  def update_columns(...)
    raise_readonly_record
  end

  def destroy(...)
    raise_readonly_record
  end

  def destroy!(...)
    raise_readonly_record
  end

  def delete(...)
    raise_readonly_record
  end

  def touch(...)
    raise_readonly_record
  end

  def increment!(...)
    raise_readonly_record
  end

  def decrement!(...)
    raise_readonly_record
  end

  def toggle!(...)
    raise_readonly_record
  end

  private

  def raise_readonly_record
    self.class.send(:raise_readonly_record)
  end
end
