# etp-gc.tcl

ad_library {
    Demo for using general comments with ETP

    @cvs-id $Id$
    @author Pat Colgan pat@museatech.net
    @creation-date 20 June 2001
}

namespace eval etp {

ad_proc -public get_gc_link { } {
    Called from rotisserie questions template to present comment link
    taking out permission checking for now
    @author Pat Colgan pat@museatech.net
    @creation-date 4-17-01
} {

    # get object_id
    # check permissions
    # return link

    # We only show the link here if the_public has 
    # general_comments_create privilege on the page.  Why the_public
    # rather than the current user?  Because we don't want admins to
    # be seeing "Add a comment" links on non-commentable pages.
    #
    set item_id $pa.item_id
    set object_name [etp::get_name]
    set comment_link ""

	append comment_link "<center>
	[general_comments_create_link -object_name $object_name $item_id ]
	</center>"
    
    append comment_link "[general_comments_get_comments -print_content_p 1 $item_id ]"
    return $comment_link
}
}












































