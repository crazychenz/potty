#!/bin/sh

/projects/stable/engine/Godot_v3.2.1-stable_win64.exe \
    -v --no-window -s addons/gutlite/gutlite_cli.gd -gexit \
    -gtest=res://test/unit/test_model.gd

#    -gtest=res://test/unit/test_grid.gd