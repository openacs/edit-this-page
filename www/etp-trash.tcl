# /packages/edit-this-page/www/etp-trash.tcl

ad_page_contract {
    @author Luke Pond (dlpond@pobox.com)
    @creation-date 2001-07-25

    Moves the item to the "Trash" folder so we can
    recover it later if necessary.  There is no annoying
    confirmation message.

} {
    item_id:integer
}

etp::check_write_access

set package_id [ad_conn package_id]

if {![db_0or1row get_node_id ""]} {
    set node_id ""
} else {

    # You can't delete a site node if it has any children 
    if {[db_string site_node_children ""] > 0} {
	ad_return_warning "Unable to delete content section" "
	Sorry, this subtopic contains other subtopics.
	You should remove them first; then you'll be able to
	remove this one.  If Edit This Page isn't showing any
	subtopics, you
	may need to use the <a href=\"/admin/site-map/\">Site Map</a>.
	"
	ad_script_abort
    }
}
    


db_transaction {

    if {![empty_string_p $node_id]} {
	site_map_unmount_application -delete_p "t" $node_id    
    }

    # If an item with the same name is already in the trash,
    # rename this item to "Copy of foo".
    while {[db_string matching_name ""] > 0} {
	db_dml update_name ""
    }

    db_dml trash_item ""

}
ad_returnredirect "etp"
ad_script_abort

