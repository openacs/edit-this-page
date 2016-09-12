
<property name="context">{/doc/edit-this-page {Edit This Page}} {Installation instructions}</property>
<property name="doc(title)">Installation instructions</property>
<master>
<h2>Installation instructions</h2>
<br clear="right">
<a href="./">ETP Documentation</a>
:Install

I&#39;m assuming you&#39;ve already installed OpenACS 4, loaded the
data model, and you can see the "Congratulations!" page
in your web browser. First, install the ETP package by navigating
to the package manager (found at <code>acs-admin/apm</code>
), and
selecting "Load a new package from a URL or local
directory".
<p>The Package Manager will retrieve the package code, place it in
your server&#39;s <code>packages/editthispage</code> directory, and
perform the necessary database setup. When that&#39;s done,
you&#39;ll need to restart your server to load all of the
package&#39;s tcl code.</p>
<p>Now you may test the package by visiting the Site Map (found at
<code>admin/site-map</code>), creating a new directory, selecting
"new application", and choosing Edit This Page. Within
that directory, anyone who has "write" permission will
see a link that takes them to the ETP interface from which they may
edit the content of the page.</p>
<p>However, you&#39;re not really having fun until you can modify
your home page through your web browser. If you go the Main Site
Administration page, and click on Parameters, you can set the URL
for the main site, under IndexRedirectUrl. If you have mounted an
Edit-this-page instance at /intranet, for example, you can enter
intranet here, and requests for the main page (/) will be
redirected to the Edit this page instance (/intranet).</p>
<p>Or, if you want requests for (/) to still go to /, then by
entering the following commands, you&#39;ll set up your site so
that Edit This Page can also serve pages at the top level of the
URL hierarchy, including your home page. Doing this will not
prevent access to the top-level admin pages; the acs-subsite
package remains mounted at the top level.</p>
<blockquote><pre>
cd /web/MYSERVER/www
mkdir index-backup
mv index* index-backup
ln -s ../packages/edittthispage/www/index.vuh .
</pre></blockquote>
<hr>
<table width="100%"><tbody><tr><td><address><a href="mailto:luke\@museatech.net">luke\@museatech.net</a></address></td></tr></tbody></table>
