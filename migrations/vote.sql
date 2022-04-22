-- 1 up
create table if not exists posts (
  id    integer primary key autoincrement not null,
  title text,
  announce text,
  body  text,
  liked integer not null,
  unliked integer not null
);
insert into posts values ((SELECT max(id) FROM posts)+1, 'I ♥ Mojolicious!', 

'Mojolicious is a fresh take on Perl web development, 
based on years of experience developing the Catalyst framework, 
and utilizing the latest web standards and technologies. 
You can get started with your project quickly, with a framework that grows with your needs.',

'Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Cras sed dapibus nulla. Fusce et ultrices urna. 
Interdum et malesuada fames ac ante ipsum primis in faucibus. 
Curabitur maximus dui eget nibh ullamcorper interdum. 
Cras tincidunt turpis vitae erat volutpat consequat. 
Nullam efficitur mi vitae finibus auctor. 
Duis malesuada quis erat sagittis malesuada. 
Nulla facilisi. Phasellus sed mi sed quam faucibus iaculis. 
Sed vel nunc blandit leo tempus hendrerit nec nec quam. 
Sed elementum tempus molestie. In congue tincidunt ultrices. 
In porta vel erat at placerat. Fusce venenatis euismod lorem eget tempor. 
Ut eu tellus metus.',

1000,

0
);

insert into posts values ((SELECT max(id) FROM posts)+1, 'Announcing Mojolicious 9.0', 

'The Mojolicious Core Team is delighted to announce the release and immediate 
availability of version 9.0 of the Mojolicious real-time web framework.',

'The Mojolicious Core Team is aware that more and more deployments are 
in containers and cloud services these days and we have been thinking of ways 
to make that easier. With 9.0 we haveve added two new features specifically 
designed to help with these types of deployments.',

1100,

0
);

-- 1 down
drop table if exists posts;

-- 2 up
create table if not exists ausers (
  id    integer primary key autoincrement not null,
  login varchar(255),
  pass varchar(255),
  email varchar(255)
);

insert into ausers values ((SELECT max(id) FROM ausers)+1, 'loginTest1', 'passTest1', 'loginTest1@gmail.com');
insert into ausers values ((SELECT max(id) FROM ausers)+1, 'loginTest2', 'passTest2', 'loginTest2@gmail.com');
insert into ausers values ((SELECT max(id) FROM ausers)+1, 'loginTest3', 'passTest3', 'loginTest3@gmail.com');
-- 2 down
drop table if exists ausers;