class QuizActivityElastic < ElasticRails

	def initialize
		super "quiz_activities"
	end

    private

    def create_body value
    	{index: {_index: @custom_index[:write], _type: value[:context] , _id: value[:id], data: value }}
    end

    def mapping
	    {
	     document: {
	        properties: {	           
	           community_id: {
	              type: "long"
	           },
	           community_name: {
	              type: "string",
	              index: "no"
	           },
	           context: {
	              type: "string",
	              index: "no"
	           },
	           created_at: {
	              type: "date",
	              format: "dateOptionalTime"
	           },
	           discipline_id: {
	              type: "long"
	           },
	           discipline_name: {
	              type: "string"
	           },
	           earned_sticker: {
	              type: "boolean",
	              index: "no"
	           },
	           id: {
	              type: "long"
	           },
	           level_up: {
	              type: "boolean",
	              index: "no"	              
	           },
	           lis_result_sourcedid: {
	              type: "string"
	           },
	           original_score: {
	              type: "double",
	              index: "no"
	           },
	           poks_given: {
	              type: "long",
	              index: "no"
	           },
	           quiz_activity_id: {
	              type: "string"
	           },
	           resource_link_id: {
	              type: "string"
	           },
	           school_grade_id: {
	              type: "long"
	           },
	           school_grade_name: {
	              type: "string"
	           },
	           school_id: {
	              type: "long"
	           },
	           school_name: {
	              type: "string"
	           },
	           score: {
	              type: "long",
	              index: "no"
	           },
	           sticker: {
	              properties: {
	                 id: {
	                    type: "long",
	              		index: "no"
	                 },
	                 name: {
	                    type: "string",
	              		index: "no"
	                 },
	                 url: {
	                    type: "string",
	              		index: "no"
	                 }
	              }
	           },
	           student_id: {
	              type: "long"
	           },
	           student_name: {
	              type: "string"
	           },
	           student_score_after: {
	              type: "long",
	              index: "no"
	           },
	           student_score_before: {
	              type: "long",
	              index: "no"
	           },
	           time: {
	              type: "double",
	              index: "no"
	           },
	           updated_at: {
	              type: "date",
	              format: "dateOptionalTime"
	           }
	        }
	     }
	  }
    end

    def denormalize id = nil
	    connect = ActiveRecord::Base.connection

	    collumns = [
	      "quiz_activities.*",
	      "disciplines.id as discipline_id",
	      "disciplines.description as discipline_name",
	      "students.id as student_id",
	      "students.name as student_name",
	      "communities.id as community_id",
	      "communities.name as community_name",
	      "school_grades.id as school_grade_id",
	      "school_grades.description as school_grade_name",
	      "schools.id as school_id",
	      "schools.name as school_name"
	    ]

	    query_select = "SELECT "+collumns.join(",")+" FROM quiz_activities"
	    query_join =  " INNER JOIN student_communities ON(quiz_activities.student_id = student_communities.student_id)"
	    query_join += " INNER JOIN disciplines ON(quiz_activities.discipline_id = disciplines.id)"
	    query_join += " INNER JOIN students ON(student_communities.student_id = students.id)"
	    query_join += " INNER JOIN communities ON(student_communities.community_id = communities.id)"
	    query_join += " INNER JOIN school_grades ON(communities.school_grade_id = school_grades.id)"
	    query_join += " INNER JOIN schools ON(communities.school_id = schools.id)"
	    where =       " WHERE student_communities.state = 'approved'"
	    where +=      " AND quiz_activities.id = #{id}" unless id.nil?
	    order_by =    " ORDER BY quiz_activities.created_at DESC"

	    query = query_select+query_join+where+order_by
	    results = connect.select_all(query)
	    
	    results.each{|result|
	      JSON.parse(result["data"]).each{|key,value| result[key] = value }
	      result.delete "data"
	    }
	    
	    results
	end
end