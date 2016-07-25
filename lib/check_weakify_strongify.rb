#!/usr/bin/env ruby
'''
This script is inspired by one of my colleague
'''

require 'find'

'''
Ignore some cases that no need to consider circular reference
'''
def isValidBlock(line)
    # common filters
    commonFilters = ['mas_makeConstraints', 'mas_remakeConstraints', 'mas_updateConstraints', 'animateWithDuration', 'animations', 'enumerateObjectsUsingBlock', 'enumerateKeysAndObjectsUsingBlock', 'dispatch_', 'sd_setImageWithURL', 'mapCar', 'dismissViewControllerAnimated', 'MTSegmentedControl', '@within_main_thread', 'createSignal', 'showAlertView']
    # custom filters
    selfDefineFilters = ['getFromURL', 'withAutoReloadingData', 'registerPortalWithHandler', 'registerPortalWithBlock', 'transferFromViewController', 'getFromURL', 'locatedCity', 'completion:^(BOOL finished)', 'environment', 'SAKPortalable', 'FactoryBlock', 'dismissed', 'canceled']
    
    isValid = true
    for filter in commonFilters
        if line.include?(filter)
            isValid = false
            break
        end
    end
    
    for filter in selfDefineFilters
        if line.include?(filter)
            isValid = false
            break
        end
    end
    
    return isValid
end


def blockCheckWeakify(path)
    checkCount = 0

    Find.find(path) do |f| 
        if File.basename(f) =~ /.*\.m$/
            hasWrong = false                     
            File.open(f) do |file|
                hasWrong = false
            
                # the content in the block bracket
                blockString = ''
                # the block definition and the block content
                fullBlockString = ''
                bigAbstractRange = false
                abstractCount = 0
                # the line number of the block
                lineIndex = 0

                while line = file.gets
        
                    if (bigAbstractRange && line.include?('{'))
                        abstractCount += 1
                    end
        
                    if (bigAbstractRange && line.include?('}'))
                        if (abstractCount != 0)
                            abstractCount -= 1
                        else 
                            # indicate the end of the block
                            bigAbstractRange = false;
                        
                            unless(blockString.include?('strongify') || blockString.include?('weakSelf'))
                                if (blockString.include?('self'))
                                    hasWrong = true
                                    checkCount += 1
                                    puts "Line：#{lineIndex}"
                                    puts "\n"
                                    fullBlockString += blockString
                                    puts fullBlockString
                                end
                            end
                        
                            blockString = ''
                            fullBlockString = ''
                            abstractCount = 0
                        end
                    end
        
                    # update the block content
                    if (bigAbstractRange)
                        blockString += line
                    end
        
                    # indicate the start of the block
                    if (line.include?('^') && line.include?('{') && isValidBlock(line))
                        bigAbstractRange = true
                        fullBlockString += line
                    end
                
                    lineIndex += 1
                end
            end
        
            # separate each record by multiple empty lines
            if (hasWrong)
                puts f
                puts "\n"
                puts "\n"
                puts "\n"
                puts "\n"
            end
        end
    end

    puts "Total: #{checkCount}"
end

if ARGV.count < 1
    puts  'Usage: ruby check_weakify_strongify.rb folder'
    return
end
blockCheckWeakify(ARGV[0])
