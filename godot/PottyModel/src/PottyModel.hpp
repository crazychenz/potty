#include <Godot.hpp>
#include <Node.hpp>
#include <Vector2.hpp>
#include <PoolArrays.hpp>
#include <String.hpp>
#include <model/Vector2.hpp>
#include <dummy/ConsoleEngine.hpp>
#include <dummy/IPottyModel.hpp>

using godot::Godot;

class PottyModel : public IPottyModel, public godot::Node {
    GODOT_CLASS(PottyModel, godot::Node);

    ConsoleEngine engine;
    double time_passed = 0;

public:
    PottyModel(const char *config_path = "potty-config.json") : engine(*this, config_path) { }

    /** `_init` must exist as it is called by Godot. */
    void _init() {
        //Godot::print("This is test from init");
    }

    void _process(float delta) {
        time_passed += (double)delta; // * speed;
        engine.update((double)delta);
    }

    void start_new_game()
    {
        engine.start_new_game();
    }

    bool currently_playing()
    {
        return engine.currently_playing();
    }

    void player_move(godot::Vector2 vec) {
        //Godot::print("Player moved ");
        engine.player_move(Vector2(vec.x, vec.y));
    }

    int grid_width() const {
        return engine.grid_width();
    }

    int grid_height() const {
        return engine.grid_height();
    }

    godot::String grid_ascii_state() {
        return godot::String(engine.grid_ascii_state()->c_str());
    }

    godot::Variant method(godot::Variant arg) {
        godot::Variant ret;
        ret = arg;

        return ret;
    }

    virtual void reset_level()
    {
        engine.reset_level();
    }

    virtual void next_level()
    {
        engine.next_level();
    }

    virtual void goal_reached(int stars)
    {
        emit_signal("goal_reached", stars);
    }

    virtual void game_beat(int stars)
    {
        emit_signal("game_beat", stars);
    }

    virtual void game_failed()
    {
        emit_signal("game_failed");
    }

    virtual void happiness_updated(int value)
    {
        emit_signal("happiness_updated", value);
    }

    virtual void bladder_updated(int value)
    {
        emit_signal("bladder_updated", value);
    }

    void on_updated()
    {
        //Godot::print("PottyModel.hpp: updated signal");
        emit_signal("updated");
    }

    void meta_update(std::string &meta)
    {
        emit_signal("meta_update", godot::String(meta.c_str()));
    }

    // TODO: Add parameters to this.
    void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves)
    {
        //Godot::print("PottyModel.hpp: updated_precommit signal");
        godot::PoolVector2Array sources;
        for (auto itr = simple_moves->begin(); itr != simple_moves->end(); itr++)
        {
            Vector2 &entry = *itr;
            sources.push_back(godot::Vector2(entry.getX(), entry.getY()));
        }
        emit_signal("updated_precommit", sources);
    }

    void do_commit()
    {
        //Godot::print("PottyModel.hpp: do_commit on engine");
        engine.do_commit();
    }

    void player_pull(bool value)
    {
        engine.player_pull(value);
    }

    virtual void pause_bladder(bool value)
    {
        engine.pause_bladder(value);
    }

    static void _register_methods() {
        godot::register_method("_process", &PottyModel::_process);
        godot::register_method("player_move", &PottyModel::player_move);
        godot::register_method("grid_width", &PottyModel::grid_width);
        godot::register_method("grid_height", &PottyModel::grid_height);
        godot::register_method("grid_ascii_state", &PottyModel::grid_ascii_state);
        godot::register_method("do_commit", &PottyModel::do_commit);
        godot::register_method("player_pull", &PottyModel::player_pull);
        godot::register_method("start_new_game", &PottyModel::start_new_game);
        godot::register_method("currently_playing", &PottyModel::currently_playing);
        godot::register_method("reset_level", &PottyModel::reset_level);
        godot::register_method("next_level", &PottyModel::next_level);
        godot::register_method("pause_bladder", &PottyModel::pause_bladder);

        /**
         * The line below is equivalent to the following GDScript export:
         *     export var _name = "PottyModel"
         **/
        godot::register_property<PottyModel, godot::String>("base/name", &PottyModel::_name, godot::String("PottyModel"));

        /** Alternatively, with getter and setter methods: */
        godot::register_property<PottyModel, int>("base/value", &PottyModel::set_value, &PottyModel::get_value, 0);

        /** Registering a signal: **/
        godot::register_signal<PottyModel>("updated");

        godot::register_signal<PottyModel>("goal_reached", "stars", GODOT_VARIANT_TYPE_INT);
        godot::register_signal<PottyModel>("game_beat", "stars", GODOT_VARIANT_TYPE_INT);
        godot::register_signal<PottyModel>("game_failed");

        godot::register_signal<PottyModel>("happiness_updated", "value", GODOT_VARIANT_TYPE_INT);
        godot::register_signal<PottyModel>("bladder_updated", "value", GODOT_VARIANT_TYPE_INT);

        /** Registering a signal: **/
        godot::register_signal<PottyModel>("meta_update", "meta", GODOT_VARIANT_TYPE_STRING);

        // TODO: Add parameters to this.
        godot::register_signal<PottyModel>("updated_precommit", "sources", GODOT_VARIANT_TYPE_POOL_VECTOR2_ARRAY);
        //godot::emit_signal("updated");
        // register_signal<PottyModel>("signal_name", "string_argument", GODOT_VARIANT_TYPE_STRING)
        //register_signal<GDExample>((char *)"position_changed", "node", GODOT_VARIANT_TYPE_OBJECT, "new_pos", GODOT_VARIANT_TYPE_VECTOR2);
    }

    godot::String _name;
    int _value;

    void set_value(int p_value) {
        _value = p_value;
    }

    int get_value() const {
        return _value;
    }
};
