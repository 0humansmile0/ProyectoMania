if visible and CHARACTER.references.current_player == PLAYERS.Explorer {
	hunger++;
	other.Update();
	visible = false;
}