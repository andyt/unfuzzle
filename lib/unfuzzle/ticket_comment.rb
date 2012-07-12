module Unfuzzle

  # = Ticket
  #
  # Represents a single Unfuddle Ticket - is associated to a project
  # and optionally a project's milestone.  Has the following attributes:
  #
  # [id] The unique identifier for this ticket
  # [number] The ticket's number - this is displayed in the web interface
  # [title] The title of the ticket (short)
  # [description] The full description of the ticket
  # [status] The ticket's status (new / accepted / resolved / closed)
  # [due_on] The due date for this ticket
  # [created_at] The date/time that this ticket was created
  # [updated_at] The date/time that this ticket was last updated
  #
  class TicketComment

    include Graft

    attribute :id, :type => :integer
    attribute :ticket_id, :from => 'parent-id', :type => :integer
    attribute :author_id, :from => 'author-id', :type => :integer
    attribute :body
    attribute :body_format, :from => 'body-format'
    attribute :body_formatted, :from => 'body-formatted'
    attribute :created_at, :from => 'created-at', :type => :time
    attribute :updated_at, :from => 'updated-at', :type => :time

    # Return a list of all ticket comments for an individual project
    def self.find_all_by_project_id(project_id)
      response = Request.get("/projects/#{project_id}/tickets/comments")
      collection_from(response.body, 'comments/comment')
    end

    # Hash representation of this ticket's data (for updating)
    def to_hash
      {
        'id'           => id
      }
    end
    
    # Update the comment's data in unfuddle
    def update
      resource_path = "/projects/#{project_id}/tickets/{#ticket_id}/comments/#{id}"
      Request.put(resource_path, self.to_xml('ticket'))
    end

  end
end