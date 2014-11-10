(->
	classChain = []

	getSuperClass = (subClass) ->
		return null if !subClass
		for cls in classChain
			return cls.superClass if cls.cls == subClass

	getInitializer = (_cls) ->
		return null if !_cls
		for cls in classChain
			return cls.initialize if cls.cls == _cls
		
	window.createClass = (superClass, classCreator) ->
		(classCreator = superClass; superClass = null) if arguments.length == 1
		return null if typeof classCreator != 'function'
		$parent = superClass
		$parents = []
		$parents.push superClass if superClass
		while getSuperClass($parent)
			$parent = getSuperClass($parent)
			$parents.push $parent
		cls = ->
			self = this
			$self = {}
			classInitializers = []
			originalInitializers = []
			for $parent in $parents
				originalInitializers.unshift getInitializer($parent)
			originalInitializers.push initialize
			for _initializer in originalInitializers
				((_initializer) ->
					classInitializers.push(->
						$self.initialize = classInitializers.pop() || (->)
						args = [self, $self]
						for arg in arguments
							args.push arg
						_initializer.apply self, args
						delete $self.initialize
						return if _initializer == initialize
						$super = {}
						$super.$super = $self.$super if $self.$super
						for k, v of $self
							$super[k] = v if typeof v == 'function'
						$self.$super = $super
					)
				)(_initializer)
			classInitializers.pop().apply(self, arguments)
			return
		initialize = classCreator(cls)
		classChain.push {
			cls: cls
			superClass: superClass
			initialize: initialize
		}
		return cls
)()