ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-10

    Presents a form for editing a single page attribute 

} {
    name
    attribute
} -properties {
    page_title:onevalue
    context:onevalue
    attribute_title:onevalue
    widget:onevalue
    form_vars:onevalue
}

etp::check_write_access

set package_id [ad_conn package_id]
set revision_id [etp::get_latest_revision_id $package_id $name]
set content_type [etp::get_content_type $name]
set attribute_desc [etp::get_attribute_desc $attribute $content_type]

ns_log Notice "etp-edit: attr_desc is $attribute_desc"
set attribute_title [etp::get_attribute_pretty_name $attribute_desc $name]

# figure out the attribute's value

if { [lsearch -exact {title description content} $attribute] >= 0 } {
    # value is stored in cr_revisions table

    db_1row get_standard_attribute ""

} else {
    # value is stored in acs_attribute_values
    set attribute_id [etp::get_attribute_id $attribute_desc]
    db_1row get_extended_attribute ""
}


# TODO: need to implement select lists also
# TODO: what about default values?

set type [etp::get_attribute_data_type $attribute_desc]
set html [etp::get_attribute_html $attribute_desc]
set default [etp::get_attribute_default $attribute_desc]

ns_log Notice "default is $default; [info commands $default]"

# see if a select-list callback function was specified
if { [info commands $default] != "" } {
    set query_results [eval $default option_list $attribute_id]
    set widget "<select name=\"$attribute\">\n"
    foreach pair $query_results {
	if {[lindex $pair 0] == $value} {
	    append widget "<option value=\"[lindex $pair 0]\" selected>[lindex $pair 1]</option>\n"
	} else {
	    append widget "<option value=\"[lindex $pair 0]\">[lindex $pair 1]</option>\n"
	}
    }
    append widget "</select>\n"
} elseif {$type == "string" && [regexp -nocase {(rows|cols)} $html]} {
    set widget "<textarea name=\"$attribute\" $html>[ad_quotehtml $value]</textarea>\n"
} elseif {$type == "date"} {
    if [empty_string_p $value] {
	set widget [ad_dateentrywidget datevalue]
    } else {
	# Put the date back into YYYY-MM-DD format
	set date_format [etp::get_application_param date_format]
	set value [db_string transform_date ""]
	set widget [ad_dateentrywidget datevalue $value]
    }
} else {
    set widget "<input type=\"text\" name=\"$attribute\" value=\"[ad_quotehtml $value]\" $html>\n"
}

set form_vars [export_form_vars name attribute]

set page_title "$attribute_title for page '$page_title'"

if {$name == "index"} {
    set context [list [list "etp?[export_url_vars name]" Edit] $attribute_title]
} else {
    set context [list [list $name $name] [list "etp?[export_url_vars name]" Edit] $attribute_title]
}



