A = createClass((Class)->
	# private static variable
	counter = 0
	# private static method
	countInstance = ->
		counter++; return
	# public static method
	Class.instanceCount = ->
		counter
	# class initiation method, where:
	# self: the instance object
	# $self: the context for protected members
	(self, $self, id) ->
		$self.initialize() # call super class constructor.
		countInstance()
		# private variable: id
		# private method
		getClassName = ->
			"A"
		# protected variables
		$self.id = id
		# protected method
		$self.present = ->
			"#{getClassName()} # #{$self.id}"
		# public methods
		self.print = ->
			console.log "<#{$self.present()}>"
)

B = createClass(A, (Class) ->
	counter = 0
	countInstance = ->
		counter++; return
	Class.instanceCount = ->
		counter
	(self, $self, id) ->
		$self.initialize(id) # call super class constructor.
		countInstance()
		getClassName = ->
			"B"
		# override
		$self.present = ->
			"#{getClassName()} : #{$self.$super.present()}"
)

a = new A('001')
b = new B('002')
a.print()
b.print()
console.log A.instanceCount()
console.log B.instanceCount()