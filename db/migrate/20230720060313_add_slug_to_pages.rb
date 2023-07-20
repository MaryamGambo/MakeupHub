class AddSlugToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :permalink, :string
  end
end
