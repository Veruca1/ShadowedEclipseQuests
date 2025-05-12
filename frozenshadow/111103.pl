sub EVENT_DEATH_COMPLETE {
    quest::set_data("mrs_norris_x", $x);
    quest::set_data("mrs_norris_y", $y);
    quest::set_data("mrs_norris_z", $z);
    quest::set_data("mrs_norris_h", $h);

    quest::signalwith(1776, 3, 0);
}
