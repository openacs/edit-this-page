# edit-this-page/tcl/etp-sc-procs.tcl
# implements OpenFTS Search service contracts
# Dave Bauer dave@thedesignexperience.org
# 2002-08-13

# Right now I am leaving the keywords blank
# in the future we should either extract them from the META keyword tag
# or allow assignment of cr_keywords to static_pages

# 2003-01-13 added procs to create new service contract implementations
# when a new application type is added -DaveB


namespace eval etp {}

ad_proc etp::revision_datasource {
    object_id
} {
    Returns a search package compatible array
    @author Dave Bauer
} {
        
    db_0or1row revision_datasource ""     -column_array datasource
    set content_type [db_string get_content_type {}]
    ns_log debug "etp::revision_datasource: content_type=$content_type"
    # call a specially named proc to extend search content for
    # this content_type if it exists
    # we pass in the name of the tcl array for the datasource
    # which the proc can modify if it likes to add additional
    # content to be indexed.

    if {[llength [info procs "etp::search::$content_type"]]==1} {
	[etp::search::$content_type -array_name "datasource"]
    }

    return [array get datasource]
}

ad_proc etp::revision_url {
    object_id
} {
    returns the url of an etp page revision 
    @author Dave Bauer
} {
    db_1row revision_url {}
  
    set package_url [db_string package_url {} -default "/"]
    
    return "[ad_url]${package_url}${url}"
}

ad_proc etp::create_search_impl {
    {-content_type:required}
} {
    Creates and registers a service contract implementation alias
    for an ETP custom application type if it does not already exist.

    This will define the datasource proc for the type as
    etp::revision_datasource. That proc will attempt to call a specially
    named tcl proc of the form etp::content_type where content_type is the
    acs_object type of the content type. If the proc does not exist only the
    attributes of the default type will be used to create the datasource.
    @author Dave Bauer
} {

    db_transaction {
	# create the implementation if it does not exist
	if {![etp::search_impl_exists_p -content_type $content_type]==1} {
	    db_exec_plsql create_search_impl {}
	    db_exec_plsql create_datasource_alias {}
	    db_exec_plsql create_url_alias {}
	}
	# install the binding if it does not exist
	if {![acs_sc_binding_exists_p "FtsContentProvider" $content_type]==1} {
	    db_exec_plsql install_binding {}
	}
    } on_error {
	ns_log Error "etp::create_search_impl: Service contract implementation for content type \"${content_type}\" is not valid"
    }
}
    

ad_proc etp::search_impl_exists_p {
    {-content_type:required}
} {
    checks for the existence of a search service contract implementation
    and returns 1 if it exists, and 0 is it does not
    @author Dave Bauer
} {
    # check for service contract here
    ns_log debug "etp::search_impl_exists_p: search_contract_exists_p content type=$content_type
                   exists_p=[acs_sc_binding_exists_p FtsContentProvider $content_type]"
    return [acs_sc_binding_exists_p FtsContentProvider $content_type]
}

namespace eval etp::search {}

ad_proc etp::search::etp_page_revision {
    {-array_name ""}
} {
    Sample Custom content type search proc
    We are allowed to add/modify the elements for the
    search compatible datasource array via upvar
} {
    if {[exists_and_not_null array_name]} {
	upvar search_array $array_name
	ns_log debug "etp::search::etp_page_revision: arrayname:$array_name"
    }
}