ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-10

    Handles updating the value for a single page attribute

} {
    name
    attribute    
} -properties {
    page_title:onevalue
    attribute_title:onevalue
    widget:onevalue
}

etp::check_write_access

set form [ns_getform]
if { [empty_string_p $form] || [ns_set find $form $attribute] == -1 } {
    ad_return_error "This is a bug" "Form must provide value for $attribute"
    ad_script_abort
}
set value [ns_set get $form $attribute]

# TODO: validate the html that was given to us

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set latest_revision_id [etp::get_latest_revision_id $package_id $name]
set live_revision_id [etp::get_live_revision_id $package_id $name]

if { $latest_revision_id == $live_revision_id } {
    # This is the first edit performed on this page since it was last
    # published.  Now's the time to make a new revision to store the changes.

    db_exec_plsql create_new_revision ""
    set latest_revision_id [etp::get_latest_revision_id $package_id $name]
}

set content_type [etp::get_content_type $name]
set attribute_desc [etp::get_attribute_desc $attribute $content_type]
set attribute_id [etp::get_attribute_id $attribute_desc]
if { $attribute_id == -1} {
    # standard attribute

    # DRB: The following code's an absolute hack, but then again the original
    # code's pretty much an absolute hack, too.   We need to sit down and make
    # some decisions about how to stuff Oracle clob and PG (and other reasonable
    # RDBMS's) long text type in an RDBMS-independent fashion.

    # This isn't as ugly as it could be in the sense that the test for clobness is
    # encapsulated in the query file.    So maybe it's not quite as ugly a hack
    # as I make it out to be ... you decide!

    if { ![empty_string_p [db_map update_${attribute}_attribute_clob]] } {
        db_dml update_${attribute}_attribute_clob "" -blobs  [list $value]
    } else {
        db_dml update_attribute ""
    }

} else {
    # extended_attribute
    db_transaction {
	db_dml delete_ext_attribute ""
	db_dml insert_ext_attribute ""
    }
}

# As a convenience, if you change the Title of an index page, 
# we also update the package instance name so that the context bar
# reflects the new title.  Note this is something you can't do through
# the Site Map UI.

if { $name == "index" && $attribute == "title" } {
    db_dml update_package_instance_name ""

}


ad_returnredirect "etp?[export_url_vars name]"
