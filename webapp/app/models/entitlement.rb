# Copyright (C) 2007, 2008, 2009 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the 
# terms of the GNU Affero General Public License as published by the 
# Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License 
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

class Entitlement < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :privilege
  
  belongs_to :jurisdiction, :class_name => 'Entity', :foreign_key => :jurisdiction_id

  class << self
    def for_jurisdiction(jurisdiction)
      jurisdiction_id = jurisdiction.to_i if jurisdiction.respond_to?('to_i')
      jurisdiction_id = jurisdiction.id if jurisdiction.is_a? Entity
      jurisdiction_id = jurisdiction.entity_id if jurisdiction.is_a? Place

      find_all_by_jurisdiction_id(jurisdiction_id)
    end
  end
end
