local const = {}

const.BLOCK_COLOR = {
	RED = 0,
	YELLOW = 1,
	BLUE = 2,
	GREEN = 3,
	MAX_COLOR = 4,
}

const.KEY_EVENT = {
	MOVE_UP = 0,
	MOVE_DOWN = 1,
	MOVE_LEFT = 2,
	MOVE_RIGHT = 3,
	RESTART = 4,
	PAUSE = 5,
	RESUME = 6,
}

const.BOX_SIZE = {
	WIDTH = 38,
	HEIGHT = 38,
}

const.BOARD_SIZE = {
	X = 10,
	Y = 20,
}

const.FLIP_TYPE = {
	NORMAL  = 0, -- 不翻转
	FLIPED  = 1, -- 翻转
}

const.BLOCK_TYPE = {
	LSHAPE = 1,
	SQUARE = 2,
	STICK  = 3,
	TSHAPE = 4,
	ZSHAPE = 5,
	TOTAL  = 6,
}

return const