# frozen_string_literal: true

require 'fox16'
include Fox

require_relative 'main_window'

app = FXApp.new("Wavelength", "MusicPlayer")
window = MainWindow.new(app)

app.create
window.show(PLACEMENT_SCREEN)
app.run
