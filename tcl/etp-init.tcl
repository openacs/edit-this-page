# etp-init.tcl

ad_library {
    Registers content types used by Edit This Page templates

    @cvs-id $Id$
    @author Luke Pond dlpond@pobox.com
    @date 31 May 2001
}

# Definitions of the attributes that belong to special content types

etp::define_content_type journal_issue "Journal Issue" "Journal Issues" {
    { publication_date "Publication Date" "Publication Dates" string "size=60" "" }
    { issue_name "Issue name" "Issue names" string "size=60" "" }
}


etp::define_content_type journal_article "Journal Article" "Journal Articles" {
    { section Section Sections string "" "" }
    { byline Byline Bylines string "" "" }
    { abstract Abstract Abstracts string "rows=24 cols=80" "" }
    { citation Citation Citations string "rows=4 cols=80" "" }
}


etp::define_content_type news_item "News Item" "News Items" {
    { location "Location" "Location" string "size=80" "" }
    { subtitle "Subtitle" "Subtitle" string "rows=4 cols=80" "" }
    { release_date "Release Date" "Release Dates" string "size=60" "" }
    { archive_date "Archive Date" "Archive Dates" string "size=60" "" }
}

# Definitions of ETP "applications".  One of these must be chosen for
# each package instance of ETP, thereby determining the behavior and
# appearance of the package and the admin pages.

# Note: when defining your own application, you can specify
# whichever of these parameters you want to change; those you leave
# unspecified will be looked up from the "default" application.

etp::define_application default {
    index_template               packages/edit-this-page/templates/article-index
    index_content_type           content_revision
    index_object_name           "subtopic"
    index_title_attr_name       "Title"
    index_description_attr_name "Description"
    index_content_attr_name     "Content"

    content_template             packages/edit-this-page/templates/article-content
    content_content_type         content_revision
    content_object_name         "page"
    content_title_attr_name       "Title"
    content_description_attr_name "Description"
    content_content_attr_name     "Content"

    allow_subtopics       t
    allow_extlinks        t
    allow_symlinks        t

    auto_page_name        ""
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
