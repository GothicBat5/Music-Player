require 'tk'

# Create the Window
root = TkRoot.new { title "Slider Example" }

label = TkLabel.new(root) do
  text "Value: 0"
  pack { padx 15; pady 15; side 'top' }
end

# Scale widget
slider = TkScale.new(root) do
  from 0
  to 100
  orient 'horizontal'
  length 300
  pack { padx 15; pady 15; side 'top' }
end

# Update 
slider.command(proc { label.text = "Value: #{slider.get}" })

Tk.mainloop
