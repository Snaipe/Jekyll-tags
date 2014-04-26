module Jekyll
	module Tags
		class CustomBlock < Liquid::Block
			def initialize(tag_name, text, tokens)
				super
				@tag = tag_name
				@options = {}
			end

			def render(context)
				tags_dir = Jekyll.configuration({})['tags_directory'] || '_tags'
				dir  = File.join(File.realpath(context.registers[:site].source), tags_dir)
				path = File.join(dir, @tag)

				partial_contents = Liquid::Template.parse(super.to_s.strip)
				contents = partial_contents.render!(context)
				context['block_contents'] = contents
				
				partial = Liquid::Template.parse(source(path, context))
				partial.render!(context)
			end

			def source(path, context)
				File.read(path, context.registers[:site].file_read_opts)
			end
		end
	end

	(configuration({})['custom_blocks'] || {}).each do |tag|
		logger.info "       Custom tags: Registering \"#{tag}\" tag"
		puts
		Liquid::Template.register_tag(tag, Tags::CustomBlock)
	end
end


