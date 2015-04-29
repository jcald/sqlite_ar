require 'ruboto/widget'
require 'ruboto/util/stack'
require 'active_record'

ruboto_import_widgets :LinearLayout, :ListView

class SqliteArActivity
  def onCreate(bundle)
    super
    setTitle 'People'

    self.content_view = linear_layout :orientation => :vertical do
      @list_view = list_view :list => []
    end
  end

  def onResume
    super
    # dialog = android.app.ProgressDialog.show(self, 'SQLite ActiveRecord Example', 'Loading...')
    Thread.with_large_stack 128 do
      require 'database'
      Database.setup(self)
      # run_on_ui_thread{dialog.message = 'Generating DB schema...'}
      Database.migrate(self)
      # run_on_ui_thread{dialog.message = 'Populating table...'}
      require 'person'
      Person.delete_all
      Person.create :name => 'Charles Oliver Nutter'
      Person.create :name => 'Jan Berkel'
      Person.create :name => 'Scott Moyer'
      Person.create :name => 'Daniel Jackoway'
      Person.create :name => 'Uwe Kubosch'
      Person.create :name => 'Roberto Gonzalez'
      people_names = Person.order(:name).all.map(&:name)
      run_on_ui_thread do
        @list_view.adapter.add_all people_names
        dialog.dismiss
      end
    end
  end
end
