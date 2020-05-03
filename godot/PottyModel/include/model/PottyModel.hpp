
#pragma once

#include <string>
#include <memory>

#include "Model.hpp"
#include "Actor.hpp"
#include "Grid.hpp"
#include "Vector2.hpp"
#include "Player.hpp"
#include "Potty.hpp"
#include "Toddler.hpp"

using namespace std;

class LevelLayout {
public:
    virtual char get_position(Vector2 position) = 0;
};

class PottyModel : public Model {

private:

    unique_ptr<Grid> grid;
    shared_ptr<Player> player;
    shared_ptr<Potty> potty;

public:

    void init_level(LevelLayout &layout);


    PottyModel(int width, int height);

    ~PottyModel();

    std::string grid_as_string();
};



//signal updated(xaction)
//signal game_over

//var last_grid_updated = 0




            
/*
func grid_as_string() -> String:
    return grid.as_string()


# Move action propogates to other objects.
# Objects are checked if they are movable.


func ready(layout) -> void:
    grid.init_empty_grid(GRID_ROWS, GRID_COLS)
    bg_grid.init_empty_grid(GRID_ROWS, GRID_COLS)
    init_level(layout)

func is_valid_position(grid_position) -> bool:
    return grid.is_valid_position(grid_position)

func get_entity_at(grid_position):
    if not grid.is_valid_position(grid_position):
        return null
    return grid.get_position(grid_position)

func perform_on(action, model, actor) -> Transaction:
    return action.perform_on(model, actor)

func perform_to(action, model, actor_dst, actor_src) -> Transaction:
    return action.perform_to(model, actor_dst, actor_src)

func perform(action, model) -> Transaction:
        return action.perform(model)

func player_perform(action) -> Transaction:
    return perform_on(action, self, player)

# This is where we receive new action transactions.
func commit_xaction(xaction : Transaction):
    # Remove all the commanded actors from the grid
    for command in xaction.commands:
        var pos = command.actor.grid_position
        grid._set_coords(pos.x, pos.y, null)

    # Apply all the commands to actors in the grid
    for command in xaction.commands:
        command.perform()
    
    emit_signal("updated", xaction)

#func player_move_right(pulling = false):
#	player.handle_action(ActionEventMove.new(player, ActionEventMove.RIGHT, pulling))
#
#
#func player_move_left(pulling = false):
#	player.handle_action(ActionEventMove.new(player, ActionEventMove.LEFT, pulling))
#
#
#func player_move_up(pulling = false):
#	player.handle_action(ActionEventMove.new(player, ActionEventMove.UP, pulling))
#
#
#func player_move_down(pulling = false):
#	player.handle_action(ActionEventMove.new(player, ActionEventMove.DOWN, pulling))

#func _process(delta: float) -> void:
#	var updated = grid.get_last_updated()
#	if updated > last_grid_updated:
#		view.update_view()
#		last_grid_updated = updated
*/