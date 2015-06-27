# etp-procs.tcl

ad_library {
    Helper procedures for Edit This Page

    @cvs-id $Id$
    @author Luke Pond dlpond@pobox.com
    @creation-date 31 May 2001
}

namespace eval etp {

set standard_attributes {
    {title Title Titles string {size="60"} "Untitled" -1}
    {description Description Descriptions string {rows=24 cols=80} "" -1}
    {content Content Content string {rows=24 cols=80} "" -1}
}

ad_proc -public make_content_type { content_type pretty_name pretty_plural attribute_metadata } {
    obsolete name; use define_content_type instead
} {
    return [define_content_type $content_type $pretty_name $pretty_plural $attribute_metadata]
}

ad_proc -public define_content_type { content_type pretty_name pretty_plural attribute_metadata } {

    Call this at server startup time to register the
    extended page attributes for a particular content type.
    It ensures that there is a corresponding entry in
    acs_object_types for the content type, and that for 
    each of the extended page attributes given there is
    an appropriate entry in acs_attributes.  Also, a
    namespace variable stores all extended page attributes
    in memory data structure for quick retrieval.
    <p>
    Extended page attribute values are stored in
    the acs_attribute_values table (so-called "generic" storage)
    to prevent the necessity of creating a table for each
    content type.  This is the reason we're not using the
    attribute procs defined in the acs-subsite package, as
    they only support type-specific storage.
    <p>
    NOTE: get the attribute metadata right the first time.
    If you decide to add a new attribute to an existing object type,
    the procedure will create it for you.  But it won't
    process updates to existing attributes or remove them.  
    You'll have to do that by hand.

    @author Luke Pond
    @creation-date 2001-05-31

    @param content_type The content type you're registering.  This name
                        must be unique across all pages that must store
                        extended page attributes.
    @param pretty_name The display name for the content type
    @param pretty_plural The plural form of the display name
    @param attribute_metadata A list of records describing each extended
         page attribute.  Each record is a list containing the following
         values (in sequence):<ul>
          <li>attribute_name
          <li>pretty_name
          <li>pretty_plural
          <li>datatype (must be one of the entries in acs_datatypes:
              string, boolean, number, integer, date, etc.)
          <li>html (a string containing html attributes for the input
                    control.  useful attributes are "size=X" to specify
                    the size of standard input controls, and "rows=X cols=X"
                    to specify the size of a textarea.  Textareas will be
                    used only if the datatype is string and html specifies
                    rows or cols.)
          <li>default_value (can either be a string denoting a single default
                             value, or the name of a callback function you've
                             defined in the etp namespace which is used to
                             provide values for select lists).
         </ul>
    # TODO: other features are needed such as making an attribute optional
    # and also specifying options for select lists.
} {
    variable content_types
    if {![info exists content_types]} {
	array set content_types [list]
    }

    # probably should use content_type functions instead
    # DaveB
    # anyway we make sure new types are children of etp_page_revision
    # ensure an entry in acs_object_types
    
    if { ![db_0or1row object_type_exists ""] } {
	db_exec_plsql object_type_create ""
    }

    set attribute_metadata_with_ids [list]

    # for each attribute, ensure an entry in acs_attributes
    foreach attribute $attribute_metadata {
	if {[llength $attribute] != 6} {
	    ns_log Error "etp::define_content_type ($content_type) failed:
	    attribute_metadata record has incorrect format"
	    return
	}
		
	set a_name [lindex $attribute 0]
	set a_pretty_name [lindex $attribute 1]
	set a_pretty_plural [lindex $attribute 2]
	set a_datatype [lindex $attribute 3]
	set a_html [lindex $attribute 4]
	set a_default [lindex $attribute 5]

	if { ![db_0or1row attribute_exists ""] } {
	    set attribute_id [db_exec_plsql attribute_create ""]
	}
	lappend attribute $attribute_id
	lappend attribute_metadata_with_ids $attribute	
    }

    set content_types($content_type) $attribute_metadata_with_ids
    # add service contract implementations for content_type if necessary
    # creates search service contract implementation if it doesn't
    # already exist
    etp::create_search_impl -content_type $content_type
}    


ad_proc -public define_application { name params } {
    TODO: Need documentation 
    TODO: Check the parameters passed in
} {
    variable application_params
    if {![info exists application_params]} {
	array set application_params [list]
    }
    set application_params($name) $params
    ns_log debug "ETP define_application name $name is $application_params($name)"
}

ad_proc -public modify_application { name params } {
    TODO: Need documentation 
    TODO: Check the parameters passed in
} {
    variable application_params
    array set param_array $application_params($name)
    array set param_array $params
    set application_params($name) [array get param_array]
    ns_log debug "ETP modify_application application $name is modified to $application_params($name)"
}

ad_proc -public get_defined_applications { } {
    returns a list of all defined applications
} {
    variable application_params
    return [lsort [array names application_params]]
}

ad_proc -public get_application_param { param_name {app ""} } {
    NYI: Need documentation
} {
    array set params [get_application_params $app]

    if { [info exists params($param_name)] } {
	return $params($param_name)
    } else {
	return ""
    }
}

ad_proc -public get_application_params { {app ""} } {
    NYI: Need documentation
} {
    variable application_params

    if { $app eq "" } {
	set app [parameter::get -parameter application -default "default"]
    }

    array set params $application_params(default)

    if { [info exists application_params($app)] } {
	array set params $application_params($app)
    }

    return [array get params]
}


ad_proc -public make_page { name {title "Untitled"} {item_id ""}} {
    @author Luke Pond
    @creation-date 2001-05-31
    @param name the name of the page you wish to create 
                in the current package

    Creates a new page (content item) with the given name 
    by inserting a row into the cr_items table, and creates 
    an initial revision by inserting a row into the cr_revisions
    table.

} {
    set package_id [ad_conn package_id]

    set content_type [etp::get_content_type $name]

    # ensure an entry in cr_items for this (package_id, name) combination

    if { ![db_0or1row page_exists ""] } {
	db_exec_plsql page_create ""
    }
}

ad_proc -public get_content_type { {name ""} } {
    @param name specify "index" to get the index_content_type parameter.
                otherwise returns the content_type parameter.

    Returns the content_type specified in the package parameters.
} {
    if { $name eq "index" } {
	set content_type [etp::get_application_param index_content_type]
    } else {
	set content_type [etp::get_application_param content_content_type]
    }
    return $content_type
}


ad_proc -public get_page_attributes { 
    {-package_id ""}
} {
    @author Luke Pond
    @creation-date 2001-05-31
    @param Optionally may specify an object type containing
    extended page attributes to be returned.
    @return Creates the pa variable in the caller's context.
    
    Creates an array variable called pa in the caller's stack frame,
    containing all attributes necessary to render the current page.
    These attributes include the standard elements from the cr_revisions
    table such as title, description, and content.  If the content_type 
    parameter is provided, any extended page attributes that 
    correspond to it will be included.  See docs for etp::make_content_type 
    to learn how this works.
    <p>
    Two database accesses are required to create the array variable.
    Once created, subsequent calls to this method will find the variable
    in a cache, unless a) any of the page attributes are changed, or b)
    the page has been flushed from the cache. (flush details TBD).
    <p>
    The complete list of standard attributes in the pa array is as follows:
    <ul>
    <li>item_id
    <li>name
    <li>revision_id
    <li>title
    <li>context_bar
    <li>context
    <li>description
    <li>publish_date
    <li>content
    <li><i>extended attributes, if any, defined by etp::make_content_type</i>
    </ul>
} {
    # TODO: I have no idea if ns_cache automatically flushes
    # items that are out of date.  Must find out or risk
    # running out of memory

    set max_age [parameter::get -parameter cache_max_age -default 600]
    
    if {$package_id eq ""} {
        set package_id [ad_conn package_id]
    }
    set name [etp::get_name]
    set content_type [etp::get_content_type $name]

    upvar pa pa

    if { [catch {
	if {[empty_string_p [ad_conn -get revision_id]]} {
	    # asking for the live published revision
	    set code "etp::get_pa $package_id $name $content_type"
	    array set pa [util_memoize $code $max_age]
	} else {
	    # an admin is browsing other revisions - do not use caching.
	    array set pa [etp::get_pa [ad_conn package_id] $name $content_type]
	}
    } errmsg] } {
	ns_log warning "Error from etp::get_pa was:\n$errmsg"

	# Page not found.  Redirect admins to setup page;
	# otherwise report 404 error.
	if { $name eq "index" && 
	     [permission::permission_p -object_id [ad_conn package_id] -privilege admin] } {
	    # set up the new content section
	    ad_returnredirect "etp-setup-2"
	} else {
	    ns_returnnotfound
	}
	# we're done responding to this request, so do no 
	# further processing on this page
	ad_script_abort
    }

}


ad_proc -private get_pa { package_id name {content_type ""} } {
    @author Luke Pond
    @creation-date 2001-05-31
    @param package_id The package_id for the current request

    @param name The page name of the current request.
    @return The tcl array (in list form) of page attributes.

    Does the real work of setting up the page-attribute array,
    which is then fed to the cache. The (package_id name) 
    combination uniquely identifies a page.
} {

    set extended_attributes [get_ext_attribute_columns $content_type]

    set revision_id [ad_conn revision_id]
    if {$revision_id eq ""} {
	# this will throw an error if the page does not exist
	db_1row get_page_attributes "" -column_array pa
    } else {
	# revision_id was set by index.vuh
	db_1row get_page_attributes_other_revision "" -column_array pa
    }

    if {$pa(mime_type) eq ""} {
	set pa(mime_type) "text/html"
    }

    if {"text/html" ne $pa(mime_type) } {
	set pa(content) [template::util::richtext get_property html_value [list $pa(content) $pa(mime_type)]]
    }
    # add in the context bar
    if { $name eq "index" } {
	set cb [ad_context_bar]
        set context [list]
    } else {
	set cb [ad_context_bar $pa(title)] 
        set context [list $pa(title)]
    }
    # remove the "Your Workspace" link, so we can cache this context
    # bar and it will work for everyone

    regsub {^<a href="/pvt/home">Your Workspace</a> : } $cb "" cb

    if {[lindex $cb 1] eq "Your Workspace"} {
	set cb [lreplace $cb 0 1]
    }
    set pa(context_bar) $cb
    set pa(context) $context

    return [array get pa]
}

ad_proc -public get_ext_attribute_columns { content_type } {
	 Constructs some dynamic SQL to get each
	 of the extended page attributes.  note
	 that the attribute values are stored for
	 each *revision*, so we look them up based
	 on the live revision id, not on the item id.
} {
    set extended_attributes ""
    if { $content_type ne "" && 
         $content_type ne "etp_page_revision" } {
	variable content_types

	set attributes $content_types($content_type)

	foreach attribute_desc $attributes {
	    set lookup_sql [etp::get_attribute_lookup_sql $attribute_desc]
	    append extended_attributes ",\n $lookup_sql"
	}
    }
    return $extended_attributes
}

ad_proc -public get_attribute_descriptors { content_type } {
    returns a list of attribute descriptors for the given content_type.
    this includes standard attributes as well as extended attributes.
} {
    variable standard_attributes
    variable content_types

    if {[info exists content_types($content_type)]} {
	return [concat $standard_attributes $content_types($content_type)]
    }

    return $standard_attributes
}

ad_proc -public get_attribute_desc { name content_type } {
    returns the attribute descriptor for the given attribute.
    works for extended attributes defined by the given content_type
    as well as for the standard attributes (title, description, and content).
    (the documentation for etp_make_content_type explains what's in an
    attribute descriptor contains)
} {
    # check for standard attributes first

    variable standard_attributes

    foreach std_desc $standard_attributes {
	if { $name == [lindex $std_desc 0] } {
	    return $std_desc
	}
    }

    variable content_types
    if {[info exists content_types($content_type)]} {
	set extended_attributes $content_types($content_type)
	foreach ext_desc $extended_attributes {
	    if { $name == [lindex $ext_desc 0] } {
		return $ext_desc
	    }
	}	
    }

    return ""
}

ad_proc -public get_attribute_id { attribute_desc } {
} {
    return [lindex $attribute_desc end]
}

ad_proc -public get_attribute_name { attribute_desc } {
} {
    return [lindex $attribute_desc 0]
}

ad_proc -public get_attribute_pretty_name { attribute_desc {page_name ""} } {
} {
    set pretty_name [lindex $attribute_desc 1]

    # handle customized standard attribute names
    # which are set up with etp application parameters
    set attr_name [lindex $attribute_desc 0]
    if {$attr_name in { title description content }} {
	if { $page_name eq "index" } {
	    set param_name "index_${attr_name}_attr_name"
	} else {
	    set param_name "content_${attr_name}_attr_name"
	}

	ns_log debug "get_attribute_pretty_name: Asking for $param_name"
	set pretty_name [etp::get_application_param $param_name]
    } 

    return $pretty_name
}

ad_proc -public get_attribute_data_type { attribute_desc } {
} {
    return [lindex $attribute_desc 3]
}

ad_proc -public get_attribute_html { attribute_desc } {
} {
    return [lindex $attribute_desc 4]
}

ad_proc -public get_attribute_default { attribute_desc } {
} {
    return [lindex $attribute_desc 5]
}

ad_proc -public get_attribute_lookup_sql { attribute_desc } {
} {
    set attribute_id [etp::get_attribute_id $attribute_desc]
    set attribute_name [etp::get_attribute_name $attribute_desc]
    set default [etp::get_attribute_default $attribute_desc]

    set lookup_sql [db_map lookup_sql_clause]

    # see if a select-list callback function was specified
    if { [info commands $default] ne "" } {
	set transformed_lookup_sql [eval $default transform_during_query $attribute_id {$lookup_sql}]

	if {$transformed_lookup_sql ne ""} {
	    set lookup_sql $transformed_lookup_sql
	}
    }
    return "$lookup_sql as $attribute_name"
}

ad_proc -public get_etp_url { } {
    @author Luke Pond
    @creation-date 2001-05-31

    If the current package is an instance of Edit This Page,
    and the user has write access, returns 
    the URL to where you can edit the current page.
    <p>
    This may be called either from your master template,
    or from individual pages that are used within an ETP 
    package instance.  It incurs 1 database hit to
    do the permissions check.  The package type is acquired
    via the in-memory copy of the site-nodes layout.

} {
    set url_stub [ns_conn url]
    array set site_node [site_node::get -url $url_stub]
    set urlc [regexp -all "/" $url_stub]
    if { ($site_node(package_key) eq "edit-this-page" ||
          $site_node(package_key) eq "acs-subsite") &&
         [permission::permission_p -object_id [ad_conn package_id] -privilege write] } {

	set name [etp::get_name]

	if { ![regexp "^etp" $name] } {
	    return [export_vars -base etp { name }]
	}
    } 

    return ""

}

ad_proc -public get_etp_link { } {
    @author Luke Pond
    @creation-date 2001-05-31

    If the current package is an instance of Edit This Page,
    and the user has write access, returns 
    the html "Edit This Page" link which should be
    displayed at the bottom of the page.
    <p>
    This may be called either from your master template,
    or from individual pages that are used within an ETP 
    package instance.  It incurs 1 database hit to
    do the permissions check.  The package type is acquired
    via the in-memory copy of the site-nodes layout.

} {
    set etp_url [get_etp_url]
    if { $etp_url ne "" } {
        return [subst {<a href="[ns_quotehtml $etp_url]">Edit This Page</a>\n}]
    } 
    return {}
}

ad_proc -public get_name { } {
    @author Luke Pond
    @creation-date 2001-06-10

    Returns the canonical page name for the current request.
} {
    set url_stub [ad_conn url]
    if { [string index $url_stub end] eq "/" } {
	set name index
    } else {
	set name [file rootname [file tail $url_stub]]
    }
    return $name
}

ad_proc -public get_latest_revision_id { package_id name } {
    @author Luke Pond
    @creation-date 2001-06-10

    Returns the latest revision id for the given content item.
} {
    db_1row get_latest_revision_id ""
    return $revision_id
}

ad_proc -public get_live_revision_id { package_id name } {
    @author Luke Pond
    @creation-date 2001-06-10

    Returns the published ("live") revision id for the given content item.
} {
    db_1row get_live_revision_id ""
    return $revision_id
}

ad_proc -public get_content_items { 
    {-orderby ""}
    {-limit ""}
    {-where ""}
    {-package_id ""}
    {-result_name "content_items"}
    args
 } {
    @author Luke Pond
    @creation-date 2001-06-10 
    @param -orderby - what should appear in the ORDER BY clause
    @param -limit - number of items to return
    @param -where - additional query restrictions to follow the WHERE clause
    @param -package_id - package_id to use (by default uses [ad_conn package_id])
    @param -result_name - variable name to create in the caller's context (by default uses "content_items")
    @param args - all remaining parameters are taken to be additional page attributes to return
    Creates a variable named "content_items" in the caller's context.
    This is a multirow result set suitable for passing to an index template,
    containing all the structured data necessary to present a list of
    links to content pages/folders/extlinks/symlinks.
    
    Each row always contains values for the following page attributes:
    <ul>
    <li>name
    <li>url (use this to generate a link to this item)
    <li>title
    <li>description
    <li>object_type
    <li>publish_date
    <li>item_id
    </ul>

    Additionally, you may name additional attributes that will be
    returned, either from the standard page attributes stored in
    cr_revisions, or extended page attributes defined with 
    etp::make_content_type.
    <p>
    The content_items variable is created with a single db query,
    and currently is never cached.  

} {    

    set content_type [etp::get_content_type]

    if {$orderby eq ""} {
	set orderby [db_map gci_orderby]
    }

    if {$limit ne ""} {
	set limit_clause "limit $limit"
    } else {
	set limit_clause ""
    }

    if {$where ne ""} {
	set extra_where_clauses $where
    } else {
	set extra_where_clauses [db_map gci_where_clause]
    }

    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    } else {
	set app [parameter::get -package_id $package_id -parameter application -default default]
	set content_type [etp::get_application_param content_content_type $app]
    }

    set columns [db_map gci_columns_clause]
    ns_log debug "get_content_items: columns: $columns"
    
    for {set i 0} {$i < [llength $args]} {incr i} {
	set arg [lindex $args i]

	if {$arg in { item_id revision_id content publish_date }} {
	    append columns ",\n r.$arg"
	} else {
	    ns_log debug "get_content_items: extended attribute named $arg"
	    set attr_desc [etp::get_attribute_desc $arg $content_type]
	    if { $attr_desc ne "" } {
		ns_log debug "get_content_items: adding it"
		set lookup_sql [etp::get_attribute_lookup_sql $attr_desc]
		append columns ",\n $lookup_sql"
	    }
	}
    }
  
    upvar $result_name $result_name
    set folder_id [etp::get_folder_id $package_id]

    db_multirow $result_name get_content_items ""
}

ad_proc -public get_subtopics {} {
    @author Luke Pond
    @creation-date 2001-06-13
    
    Creates a variable named "subtopics" in the caller's context.
    This is a multirow result set suitable for passing to an index template,
    containing all the structured data necessary to present a list of
    links to subtopics.

    The columns in the "subtopics" query are: <ul>
    <li>name
    <li>title
    <li>description
    </ul>

} {
    set package_id [ad_conn package_id]    
    upvar subtopics subtopics
    db_multirow subtopics get_subtopics ""
}


ad_proc -public check_write_access {} {
    @author Luke Pond
    @creation-date 2001-08-29
    Designed to be used at the top of every ETP admin page.
    Returns an HTTP 403 Access Denied and aborts page processing
    if the user doesn't have "write" permission for the current
    package.
} {
    if { ![permission::permission_p -object_id [ad_conn package_id] -privilege write] } {
	ad_return_forbidden "Access Denied" "Sorry, you haven't been
	given permission to work on this area of the website.  Please
	contact your webmaster if you believe this to be in error."
	ad_script_abort
    }
}

ad_proc -public get_folder_id { package_id } {
    @param package_id
    @return content folder associated with package_id etp package instance
} {
    return [db_exec_plsql get_folder_id ""]
}

}
