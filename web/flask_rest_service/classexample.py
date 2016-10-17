class Dog:

    name = 'dasdas'
    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance

    def eat(self, foodName):
        pass

class Dog2:

    name = 'dasdas'
    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance

    def eat(self, foodName):
        pass