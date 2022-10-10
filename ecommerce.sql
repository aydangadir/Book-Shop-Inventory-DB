CREATE TABLE supplier(
	id int primary key auto_increment,
    supplierName char(55) unique not null,
    info text not null,
    taxCode int not null,
    mainOfficeContactNum int not null,
    contactMail char(120) not null,
    activeSince timestamp not null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null
);
CREATE TABLE supplier_locations(
	id int primary key auto_increment,
    supplierID int not null,
	address char(120) not null,
    city char(30) not null,
    country char(30) not null,
    postalCode varchar(16) not null,
    contactNum int not null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null,
    foreign key (supplierID) references supplier(id)
);
CREATE TABLE authors(
	id int primary key auto_increment,
    firstName char(55) not null,
    lastName char(55) not null,
    image varchar(2000) unique not null,
    dateOfBirth date not null,
    dateOfDeath date default null,
    nationality char(30) not null,
    info text not null,
    viewNumOnSite int not null default 0,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null
);
CREATE TABLE bookGenres(
	id tinyint primary key auto_increment,
    genreName char(20) unique not null,
    viewNumOnSite int not null default 0
);
CREATE TABLE bookCoverType(
	id tinyint primary key auto_increment,
    coverTypeName char(20) unique not null
);
CREATE TABLE languages(
	id tinyint primary key auto_increment,
    languageName char(20) unique not null
);
CREATE TABLE books_accessories(
	id int primary key auto_increment,
    `name` char(255) unique not null,
    image varchar(2000) unique not null,
    supplierID int not null, 
    bookGenreID tinyint,
    pageNum mediumint,
    bookCoverTypeID tinyint,
    languageID tinyint, 
    price float not null,
    viewNumOnSite int not null default 0,
    `description` text not null,
    rating float not null default 0,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null,
    foreign key (supplierID) references supplier(id),
	foreign key (bookGenreID) references bookGenres(id),
    foreign key (bookCoverTypeID) references bookCoverType(id),
    foreign key (languageID) references languages(id)
);
CREATE TABLE keywordTags(
	id int primary key auto_increment,
    keyword char(55) not null,
    createdAt timestamp not null,
    deletedAt timestamp default null
);
CREATE TABLE product_keywords(
	id bigint primary key auto_increment,
    keywordTagsID int not null,
    productID int not null,
    foreign key (productID) references books_accessories(id),
    foreign key (keywordTagsID) references keywordTags(id)
);
CREATE TABLE books_authors(
	id int primary key auto_increment,
	bookID int not null,
    authorID int not null,
    foreign key (bookID) references books_accessories(id),
    foreign key (authorID) references authors(id)
);
CREATE TABLE discounts(
	id int primary key auto_increment,
    `name` char(55) not null,
    books_accessoriesID int not null,
    discountPercent float not null,
    activeSince timestamp not null,
    duration int not null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null,
    foreign key (books_accessoriesID) references books_accessories(id)
);
CREATE TABLE users(
	id int primary key auto_increment,
    firstName char(55) not null,
    lastName char(55) not null,
    userName char(55) unique not null,
    loginPasswordHash binary(64) not null,
    profilePic varchar(2000) unique not null,
    userMail char(110) unique not null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null
);
CREATE TABLE userCards(
	id bigint primary key auto_increment,
    userID int not null,
    creditCardNumber int unique not null,
    cardExpiryDate date not null,
    cardHolderName char(110) not null,
    foreign key (userID) references users(id)
);
CREATE TABLE rating_comments(
	id bigint primary key auto_increment,
    userID int not null,
    isAnonymous boolean default false,
    books_accessoriesID int not null,
    rating float not null,
    comments text default null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null,
    foreign key (userID) references users(id),
    foreign key (books_accessoriesID) references books_accessories(id)
);
CREATE TABLE favorites(
	id bigint primary key auto_increment,
    userID int not null,
    books_accessoriesID int not null,
    addedAt timestamp not null,
    deletedAt timestamp default null,
    foreign key (userID) references users(id),
    foreign key (books_accessoriesID) references books_accessories(id)
);
CREATE TABLE cart(
	id bigint primary key auto_increment,
    userID int not null,
    createdAt timestamp not null,
    modifiedAt timestamp default null,
    deletedAt timestamp default null,
    foreign key (userID) references users(id)
);
CREATE TABLE cart_item(
	id bigint primary key auto_increment,
    cartID bigint not null,
    books_accessoriesID int not null,
    quantity int not null default 1,
    foreign key (cartID) references cart(id),
    foreign key (books_accessoriesID) references books_accessories(id)
);
CREATE TABLE shippingMethod(
	id tinyint primary key auto_increment,
    methodName char(20) unique not null
);
CREATE TABLE shippingStatus(
	id tinyint primary key auto_increment,
    statusName char(20) unique not null
);
CREATE TABLE ordering(
	id bigint primary key auto_increment,
    cartID bigint not null,
    shippingMethodID tinyint not null,
    `status` tinyint not null,
    userCardsID bigint not null,
    foreign key (shippingMethodID) references shippingMethod(id),
    foreign key (`status`) references shippingStatus(id),
    foreign key (userCardsID) references userCards(id)
);