var _keyid = deactivate_id;
with obj_solid {
	if deactivation_id == _keyid {
		instance_deactivate_object(id);
	}
}

instance_destroy(id);