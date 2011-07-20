Zendesk API Ruby Client
=======================

Usage
=====

Connection
----------

    @zendesk = Zendesk::Client.new do |config|
      config.account "https://coolcompany.zendesk.com"
      config.basic_auth "email@email.com", "password"
    end

    # API v2
    @zendesk = Zendesk::Client.new do |config|
      config.account "https://support.coolcompany.com"
      config.oauth token, token_secret
    end


Collections
-----------

Collections of resources are fetched as lazily as possible. For example `@zendesk.users` does not hit the API until it is iterated over
(calling `each`) or until an item is asked for (e.g., `@zendesk.users[0]`).

This laziness allows for a cool client API. Since none of the collection methods (such as `@zendesk.tickets`) make HTTP requests but
instead return self, we can chain methods in cool ways like `@zendesk.tickets.create({ ... data ... })` and `@zendesk.tickets(123).update({})`.

GET requests are not made until the last possible moment. Calling `fetch` will return the HTTP response (first looking in the cache). If you
want to avoid the cached result you can call `fetch(true)` which will force the cache to get the latest HTTP response.

PUT, POST and DELETE requests are issued immediately and respond immediately.

Users
-----

    GET
    @zendesk.users                            # all users in account
    @zendesk.users.per_page(100)              # all users in account (v2 should accept `?per_page=NUMBER`)
    @zendesk.users.page(2)                    # all users in account (v1 currently accepts `?page=NUMBER`)
    @zendesk.users.next_page                  # all users in account (v1 currently accepts `?page=NUMBER`)
    @zendesk.users(:current)                  # currently authenticated user
    @zendesk.users("Bobo")                    # all users with name matching all or part of "Bobo"
    @zendesk.users(123)                       # return user=123
    @zendesk.users("Bobo", :role => :admin)   # all users with name matching all or part of "Bobo" who are admins
    @zendesk.users(:role => :agent)           # all users who are agents
    @zendesk.users(:role => "agent")          # all users who are agents
    @zendesk.users(:group => 123)             # all users who are members of group id=123
    @zendesk.users(:organization => 123)      # all users who are members of group id=123
    @zendesk.user(123).identities             # all identities in account for a given user

    POST
    @zendesk.users.create({:name => "Bobo Yodawg",
                           :email => "bc@email.com",
                           :remote_photo_url => "http://d.com/image.png",
                           :role => :agent})

    PUT
    @zendesk.users(123).update({:remote_photo_url => "yo@dawg.com"})          # edit user=123 (data passed in overrides existing)

    @zendesk.users(123).update do |user|
      user[:remote_photo_url] = "yo@dawg.com"
    end

    @zendesk.users(123).identities.update({:email => "yo@dawg.com"})                    # add email address to user=123
    @zendesk.users(123).identities.update({:email => "yo@dawg.com", :primary => true})  # add email address to user=123
    @zendesk.users(123).identities.update({:twitter => "yodawg"})                       # add twitter handle to user=123

    DELETE
    @zendesk.users(123).delete                                                # deletes user=123

Tickets
-------
    Will have to revisit and discuss the tickets API, what is currently documented is confusing to me
    and potentially to others as well. It is not obvious how /tickets /rules/{view_id} and /requests all
    fit together. This is arguably the most important API to get right since tickets are the object most
    central to Zendesk. Things like retrieving all tickets for a single view should be simple.

    GET
    @zendesk.tickets                                                           # TODO: not supported currently
    @zendesk.tickets(123)                                                      # return ticket=123

    @zendesk.tickets(:view => 123)                                             # all tickets for view=123
    @zendesk.tickets(:view => "dev")                                           # TODO: not supported currently

    @zendesk.tickets(:tags => ["foo"])                                         # all tickets with tags=foo
    @zendesk.tickets(:tags => ["foo", "bar"])                                  # all tickets with tag=foo OR tag=bar

    @zendesk.tickets(:requester => 123)                                        # all tickets for requester=123
    @zendesk.tickets(:group => 123)                                            # all tickets for group=123
    @zendesk.tickets(:organization => 123)                                     # all tickets for organization=123
    @zendesk.tickets(:assignee => 123)                                         # all tickets for organization=123

    POST
    @zendesk.ticket_create(:description => "phone fell into the toilet",       # creates new ticket
                           :requester_id => 123,
                           :priority => :medium,
                           :tags => ["phone", "toilet"])

    @zendesk.ticket_create(:description => "phone fell into the toilet",       # creates new ticket AND new user IF email does not exist
                           :requester_name => "Snoop Dogg",
                           :requester_email => "snoop@dogg.com",
                           :priority => :medium,
                           :tags => ["phone", "toilet"])

    @zendesk.ticket_create(:tweet, :tweet_id => 123456)                        # creates new ticket from tweet

    PUT
    @zendesk.ticket_update(123, :assignee_id => 321)                           # edit ticket (data passed in overrides existing)
    @zendesk.ticket_add_tags(123, ["foo"])                                     # adds tags to ticket
    @zendesk.ticket_add_comment(123, "hi", :public => true)                    # adds comment to ticket

    DELETE
    @zendesk.ticket_delete(123)

Tags
----

    GET
    @zendesk.tags                                                              # 100 most used tags in the account
    @zendesk.tags("foo", :entries)                                             # entries matching tag=foo (limit 15)
    @zendesk.tags("foo", :tickets)                                             # tickets matching tag=foo (limit 15)
    @zendesk.tags("foo", :tickets, :page => 2)                                 # next page of tickets matching tag=foo (limit 15)
    @zendesk.tags(["foo", "bar"], :tickets)                                    # tickets matching tag=foo OR tag=bar (limit 15)

Attachments
-----------
	TODO: later...

    GET

    POST

    PUT

    DELETE

Organizations
-------------
    Organizations are for end-users

    GET
    @zendesk.organizations                                                     # all organizations in account
    @zendesk.organizations(123)                                                # returns organization=123
    @zendesk.oragnizations(123, :users => true)                                # returns organization=123 AND its members

    POST
    @zendesk.organization_create(:name => "Zoolandia")                         # creates new organization
    @zendesk.organization_create(:name => "Zoolandia",                         # TODO: not supported currently
                                 :users => [123, 345])

    PUT
    @zendesk.organization_update(123, :name => "Soopa Funk")                   # edit name of organization=123
    @zendesk.organization_update(123, :users => [123, 456])                    # TODO: not supported currently
    @zendesk.group_remove_all_users(123)                                       # TODO: not supported currently

    DELETE
    @zendesk.organization_delete(123)

Groups
------
    Groups are for Zendesk agents

    GET
    @zendesk.groups
    @zendesk.groups(123)
    @zendesk.groups(123, :users => true)

    POST
    @zendesk.group_create(:name => "Cool People", :agents => [123, 456])

    PUT
    @zendesk.group_update(123, :agents => [123, 456])
    @zendesk.group_remove_all_agents(123)

    DELETE

Forums
------
    Forums are great but the nouns are confusing. Forums, categories, entries, topics, posts
    who can keep up? For simplicity and to reinforce the idea that entries belong to forums,
    I am placing all the entry API stuff within the forum API.

    GET
    @zendesk.forums                                                            # all forums in account
    @zendesk.forums(123)                                                       # returns forum=123
    @zendesk.forums(:entry => 12345)                                           # return forum entry=12345

    @zendesk.forums(123, :entries => true)                                     # returns forum=123 AND related entries (limit 25)
    @zendesk.forums(123, :entries => true, :page => 2)                         # next 25 results for above

    POST
    @zendesk.forum_create(:name => "FAQ",                                      # creates new forum
                          :description => "get your Q's A'd",
                          :locked => false,
                          :visibility => 1)                                    # TODO: document visibility ids and use appropriate symbol

    @zendesk.forum_add_entry(123, :title => "stuff",                           # creates new entry for forum=123
                                  :body => "and stuff",
                                  :pinned => true,
                                  :locked => false
                                  :tags => ["foo", "bar"])

    PUT
    @zendesk.forum_update(123, :public => false)                               # edit forum=123
    @zendesk.forum_entry_update(123, :public => false)                         # edit forum=123

    DELETE
    @zendesk.forum_delete(123)                                                 # deletes forum=123 AND related posts and comments

Search
------

    GET

    POST

    PUT

    DELETE

Ticket Fields
-------------

    GET

    POST

    PUT

    DELETE

Macros
------

    GET

    POST

    PUT

    DELETE

