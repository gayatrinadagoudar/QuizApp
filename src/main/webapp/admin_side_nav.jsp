<nav class="navbar navbar-expand-md flex-column sideNavContainer">
<h3 class="text-primary text-center">Menu</h3>
<hr>

<ul class="nav nav-stacked">
	<li><a href="admin_users.jsp"><i class="fa fa-users fa-lg text-success"></i> All Users</a></li>
	<li><a href="admin_students.jsp"><i class="fa fa-users fa-lg text-danger"></i> Students</a></li>
	<li><a href="admin_teachers.jsp"><i class="fa fa-users fa-lg"></i> Teachers</a></li>
	<hr>
	<li><a href="#add" data-toggle="collapse" ><i class="fa fa-cogs fa-lg"></i> Settings</a></li>
	<ul class="nav collapse" id="add">
		<li><a href="admin_add_new_admin.jsp"><i class="fa fa-user-plus fa-lg"></i> Add New Admin</a>
		<li><a href="admin_change_pwd.jsp"><i class="fa fa-key fa-lg"></i> Change Password</a></li>
		</li>
	</ul>
</ul>

</nav>