extends Control

# Reference to your labels
var label1 : Label
var label2 : Label
var label3 : Label
var label4 : Label

# Create instances of your DeviceInput class for each controller
var numControllers = Input.get_connected_joypads().size()

func _ready():
	
	label1 = get_node("MarginContainer/connect_status")
	label2 = get_node("MarginContainer2/connect_status")
	label3 = get_node("MarginContainer3/connect_status")
	label4 = get_node("MarginContainer4/connect_status")
	

func _process(delta):
	
	print(Input.get_connected_joypads().size())
	
	if numControllers >= 1:
		label1.text = "Connected"
	else:
		label1.text = "Pending..."
		
	if numControllers >= 2:
		label2.text = "Connected"
	else:
		label2.text = "Pending..."
		
	if numControllers >= 3:
		label3.text = "Connected"
	else:
		label3.text = "Pending..."
		
	if numControllers >= 4:
		label4.text = "Connected"
	else:
		label4.text = "Pending..."

