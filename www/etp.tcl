ad_page_contract {
    @author Luke Pond (dlpond@museatech.net)
    @creation-date 2001-06-04

    Displays all options for editing a page

} {
    { name "index" }
} -properties {
    pa:onerow
    application_params:onerow
    subtopic_object_name:onevalue
    page_attributes:multirow
    page_url:onevalue
    content_pages:multirow
    page_title:onevalue
    context:onevalue
    subtopics:multirow
}

etp::check_write_access

# lets make etp subsite aware
# get the cloest ancestor acs-subsite
set subsite_url [site_node_closest_ancestor_package_url -package_key "acs-subsite"]
array set application_params [etp::get_application_params]
set subtopic_object_name [etp::get_application_param index_object_name [ad_parameter subtopic_application "default"]]

set package_id [ad_conn package_id]
set content_type [etp::get_content_type $name]
set extended_attributes [etp::get_ext_attribute_columns $content_type]

# as opposed to the typical use of etp::get_page_attributes, which
# gets the attributes of the live revision, these two queries get 
# the attributes of the most recent revision, and
# the results aren't cached.

set revision_id [etp::get_latest_revision_id $package_id $name]
if {![db_0or1row get_current_page_attributes "" -column_array pa]} {
    ad_return_warning "Page $name does not exist" "No page by the name of $name exists"
}

template::multirow create page_attributes name pretty_name value

proc truncate {str} {
    set str [ad_quotehtml $str]
    if {[string length $str] > 100} {
	set str "[string range $str 0 100]..."
    }
    return $str
}

set attributes [etp::get_attribute_descriptors $content_type]

foreach attribute $attributes {
    set attribute_name [etp::get_attribute_name $attribute]
    set attribute_pretty_name [etp::get_attribute_pretty_name $attribute $name]
    template::multirow append page_attributes $attribute_name \
		$attribute_pretty_name [truncate $pa($attribute_name)]
}


set page_title "Attributes for page \"$pa(title)\""
if { $name == "index" } {
    set context [list "Edit"]
} else {
    set context [list [list $name $name] "Edit"]
}

set url_dir "[file dirname [ad_conn url]]"
if { $url_dir == "/" } {
    set page_url "/$name"
    set edit_parent_url ""
} else {
    set page_url "$url_dir/$name"

    if { $name == "index" } {
	regsub {/[^/]*/[^/]*$} $page_url "" parent_url
    } else {
	set parent_url $url_dir
    }
    set edit_parent_url "$parent_url/etp"
}

if {$name == "index"} {
    # Get the list of content items in this directory
    etp::get_content_items

    #this custom query is no longer needed??  maybe it will be if we 
    #prevent newly-created pages from being displayed...
    #db_multirow content_pages get_content_pages ""
}

