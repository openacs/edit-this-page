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
set user_id [ad_conn user_id]
set old_revision_id [etp::get_latest_revision_id $package_id $name]

set content_type [etp::get_content_type $name]
set attribute_desc [etp::get_attribute_desc $attribute $content_type]

set attribute_title [etp::get_attribute_pretty_name $attribute_desc $name]
set type [etp::get_attribute_data_type $attribute_desc]
set html [etp::get_attribute_html $attribute_desc]
#transform old style ETP html attributes to ad_form style
regsub -all "=" $html " " html
set default [etp::get_attribute_default $attribute_desc]

set element $attribute

# see if a select-list callback function was specified
if { [info commands $default] ne "" } {
    set query_results [eval $default option_list $attribute_id]
    set widget select
} elseif {$type eq "string" && [regexp -nocase {(rows|cols)} $html]} {
    if {$attribute eq "content"} {

    set widget "(richtext)"

    set type richtext
} else {
    set widget "(textarea)"
}

} elseif {$type eq "date"} {
	set widget "(date),to_sql(linear_date),from_sql(sql_date)"
    set widget_extra [list format "Month DD YYYY"]
    set element datevalue

} else {
    set widget "(text)"
}
# to set values, we'll use -edit_request block or -on_request block.
# we really need to grab the item_id/revision_id

set widget_list [list $element:${type}${widget} [list label "$attribute_title"] [list html $html] ]

if {([info exists widget_extra] && $widget_extra ne "")} {
    lappend widget_list $widget_extra
}


# build dynamic form spec list
set form_list [list revision_id:key]
lappend form_list $widget_list

lappend form_list [list page_title:text(hidden)]

ad_form -name etp_edit -export { name attribute  widget} -form $form_list -edit_request {


    if {$attribute in {title description content}} {
	# value is stored in cr_revisions table

	db_1row get_standard_attribute ""

    } else {
	# value is stored in acs_attribute_values
	set attribute_id [etp::get_attribute_id $attribute_desc]
	db_1row get_extended_attribute ""
    }
    if {$widget eq "(richtext)"} {
	set $element [template::util::richtext create $value $mime_type]
    } else {
	set $element $value
    }

} -new_request {

    if {$attribute in {title description content}} {
	# value is stored in cr_revisions table

	db_1row get_standard_attribute ""

    } else {
	# value is stored in acs_attribute_values
	set attribute_id [etp::get_attribute_id $attribute_desc]
	db_1row get_extended_attribute ""
    }

    if {$widget eq "(richtext)"} {
        set $element [template::util::richtext create $value $mime_type]
    } else {
        set $element $value
    }

} -new_data {
    # usually we are creating a new revision
    set extra_sql ""
    if {[info exists datevalue]} {
	ns_log notice "DAVEB! new_data datevalue = $datevalue"

	# The date is given in YYYY-MM-DD.  Transform to desired format.
#	set date_format [etp::get_application_param date_format]
	set value "[template::util::date::get_property year $datevalue]-[template::util::date::get_property month $datevalue]-[template::util::date::get_property day $datevalue]"
    } elseif {$widget eq "(richtext)"} {
	    set value [template::util::richtext get_property contents [set $element]]
	    set mime_type [template::util::richtext get_property format [set $element]]
	    set extra_sql " , mime_type=:mime_type"

    } else {
	set value [set $element]
    }

    db_exec_plsql create_new_revision ""

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

	if { [db_map update_${attribute}_attribute_clob] ne "" } {
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

    if { $name eq "index" && $attribute eq "title" } {
	db_dml update_package_instance_name ""
    }

    ad_returnredirect [export_vars -base etp {name}]
    ad_script_abort
}

set page_title [_ edit-this-page.atribute_for_page_title]

if {$name eq "index"} {
    set context [list [list [export_vars -base etp {name}] Edit] $attribute_title]
} else {
    set context [list [list $name $name] [list [export_vars -base etp {name}] Edit] $attribute_title]
}
