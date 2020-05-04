#include <Godot.hpp>
#include <Node.hpp>
#include <Vector2.hpp>
#include <PoolArrays.hpp>
#include <String.hpp>
#include <model/Vector2.hpp>
#include <dummy/GodotModelEngine.hpp>
#include <dummy/IPottyModel.hpp>

using godot::Godot;

class PottyModel : public IPottyModel, public godot::Node {
    GODOT_CLASS(PottyModel, godot::Node);

    GodotModelEngine engine;
    double time_passed = 0;

public:
    PottyModel() : engine(*this) { }

    /** `_init` must exist as it is called by Godot. */
    void _init() {
        Godot::print("This is test from init");
    }

    void _process(float delta) {
        time_passed += (double)delta; // * speed;
        engine.update((double)delta);
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

    void commit_xaction()
    {
        return engine.commit_xaction();
    }

    godot::String grid_ascii_state() {
        return godot::String(engine.grid_ascii_state()->c_str());
    }

    godot::Variant method(godot::Variant arg) {
        godot::Variant ret;
        ret = arg;

        return ret;
    }

    void on_updated()
    {
        emit_signal("updated");
    }

    // TODO: Add parameters to this.
    void on_updated_precommit(/*Vector2 &dir, std::vector<Vector2> &srcpos*/)
    {
        /*
        godot::PoolVector2Array sources;
        for (auto itr = srcpos.begin(); itr != srcpos.end(); itr++)
        {
            Vector2 &vec = *itr;
            sources.push_back(godot::Vector2(vec.getX(), vec.getY()));
        }*/
        emit_signal("updated_precommit"/*, godot::Vector2(dir.getX(), dir.getY()), sources*/);
    }

    void do_commit()
    {
        engine.do_commit();
    }

    static void _register_methods() {
        godot::register_method("_process", &PottyModel::_process);
        godot::register_method("player_move", &PottyModel::player_move);
        godot::register_method("grid_width", &PottyModel::grid_width);
        godot::register_method("grid_height", &PottyModel::grid_height);
        godot::register_method("grid_ascii_state", &PottyModel::grid_ascii_state);
        godot::register_method("do_commit", &PottyModel::do_commit);



        godot::register_method("method", &PottyModel::method);

        /**
         * The line below is equivalent to the following GDScript export:
         *     export var _name = "PottyModel"
         **/
        godot::register_property<PottyModel, godot::String>("base/name", &PottyModel::_name, godot::String("PottyModel"));

        /** Alternatively, with getter and setter methods: */
        godot::register_property<PottyModel, int>("base/value", &PottyModel::set_value, &PottyModel::get_value, 0);

        /** Registering a signal: **/
        godot::register_signal<PottyModel>("updated");

        // TODO: Add parameters to this.
        godot::register_signal<PottyModel>("updated_precommit"/*, "direction", GODOT_VARIANT_TYPE_VECTOR2, "sources", GODOT_VARIANT_TYPE_POOL_VECTOR2_ARRAY*/);
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
