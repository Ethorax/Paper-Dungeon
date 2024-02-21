extends Node


var monsters = []

enum battle_state{
	beginning,
	turn,
	p_turn,
	e_turn,
	ending
}
var b_state = battle_state.beginning
