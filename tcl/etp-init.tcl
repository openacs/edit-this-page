# etp-init.tcl

ad_library {
    Registers content types used by Edit This Page templates

    @cvs-id $Id$
    @author Luke Pond dlpond@pobox.com
    @creation-date 31 May 2001
}

# Definitions of the attributes that belong to special content types
# and of ETP "applications".  One of "application" must be chosen for
# each package instance of ETP, thereby determining the behavior and
# appearance of the package and the admin pages.

# Note: when defining your own application, you can specify
# whichever of these parameters you want to change; those you leave
# unspecified will be looked up from the "default" application.

# DRB: I added code to guard these definitions and to only define applications if the
# type exists or is successfully created.  This is a workaround for the fact that certain
# older packages may define types with the same pretty name as an ETP type.  When such a
# package was mounted, ETP would not work.  The real-life example is news, where both the
# original news package and ETP define a content type with the pretty name "News Item".
# The name is so logical that I couldn't really see much sense in changing the name in
# one package or the other.

# This admittedly has made the code ugly but mounting news or any other package must
# not be allowed to break ETP ...

etp::define_application default {
    index_template               packages/edit-this-page/templates/article-index
    index_content_type           etp_page_revision
    index_object_name           "subtopic"
    index_title_attr_name       "Title"
    index_description_attr_name "Description"
    index_content_attr_name     "Content"

    content_template             packages/edit-this-page/templates/article-content
    content_content_type         etp_page_revision
    content_object_name         "page"
    content_title_attr_name       "Title"
    content_description_attr_name "Description"
    content_content_attr_name     "Content"

    allow_subtopics       t
    allow_extlinks        t
    allow_symlinks        t

    auto_page_name        ""

    date_format           "Month DD, YYYY"
}

if { [catch {

    etp::define_content_type journal_issue "Journal Issue" "Journal Issues" {
	{ publication_date "Publication Date" "Publication Dates" date "" "" }
	{ issue_name "Issue name" "Issue names" string "size=60" "" }
    }

} errmsg]} {
    ns_log Notice "ETP: define 'Journal Issue' failed: $errmsg"
}

if { [catch {

    etp::define_content_type journal_article "Journal Article" "Journal Articles" {
	{ section Section Sections string "" "" }
	{ byline Byline Bylines string "" "" }
	{ abstract Abstract Abstracts string "rows=24 cols=80" "" }
	{ citation Citation Citations string "rows=4 cols=80" "" }
    }

} errmsg]} {
    ns_log Notice "ETP: define 'Journal Articles' failed: $errmsg"
}


if { [catch {

    etp::define_content_type news_item "News Item" "News Items" {
	{ location "Location" "Location" string "size=80" "" }
	{ subtitle "Subtitle" "Subtitle" string "rows=4 cols=80" "" }
	{ release_date "Release Date" "Release Dates" date "size=60" "" }
	{ archive_date "Archive Date" "Archive Dates" date "size=60" "" }
    }

} errmsg]} {
    ns_log Notice "ETP: define 'News Items' failed: $errmsg"
} else {

    etp::define_application news {
        index_template                packages/edit-this-page/templates/news-index
        content_template              packages/edit-this-page/templates/news-content
        content_content_type          news_item
        content_object_name           "news item"
        allow_subtopics               f
        allow_extlinks                f
        allow_symlinks                f
        auto_page_name                "number"
    }
}


etp::define_application faq {
    index_template                packages/edit-this-page/templates/faq-index
    index_object_name             "FAQ"

    content_template              packages/edit-this-page/templates/faq-content
    content_object_name           "question"
    content_title_attr_name       "Question"
    content_content_attr_name     "Answer"

    allow_subtopics               f
    allow_extlinks                f
    allow_symlinks                f
    auto_page_name                "number"
}
