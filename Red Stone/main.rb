# frozen_string_literal: true

require 'fox16'
include Fox
require 'fiddle'
require 'fiddle/import'

module DPI
  extend Fiddle::Importer
  dlload 'user32.dll'

  extern 'bool SetProcessDPIAware()'
end

DPI.SetProcessDPIAware

require_relative 'main_window'

app = FXApp.new("Wavelength", "MusicPlayer")
window = MainWindow.new(app)

app.create
window.show(PLACEMENT_SCREEN)
app.run
