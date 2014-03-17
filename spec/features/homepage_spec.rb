require 'spec_helper'

describe "Blog", :type => :feature do
  it "should add a new album" do
    visit("/add")
    
    fill_in('album_title', :with => '"GENERALS" by The Mynabirds')
    fill_in('album_cover', :with => 'http://www.kickassmusicwomen.com/wp-content/uploads/2012/09/The-Mynabirds-Generals-608x608.jpg')
    fill_in('album_review', :with => 'Laura Burhenn proved she could craft a pop record with the Mynabirds\' 2010 debut, What We Lose in the Fire, We Gain in the Flood, a masterwork of Laurel Canyon-style blue-eyed pop soul. Her deeply political sophomore LP runs the risk of becoming another of the countless failed examples of those singer-songwriters whose best intentions fall short of qualifying as either good pop or moving rhetoric. It\'s a tough trick, translating your deeply held political conventions into good tunes. Somehow, though, Burhenn pulls it off on Generals. Back with her faithful producer Richard Swift, who continues his hot streak behind the boards, Burhenn manages to retain the pop smarts (and Biblical undertones) of Fire, reshaping them into a timely form of righteousness.')
    fill_in('rdio', :with => '<iframe width="500" height="500" src="https://rd.io/i/QUWZfCJHTMk/" frameborder="0"></iframe>')
    fill_in('place_title', :with => 'Somewhere in North Downtown Omaha')
    fill_in('city', :with => 'Omaha')
    fill_in('place_description', :with => 'Dedicated to enhancing the cultural environment of the Omaha-Council Bluffs area through the presentation and discussion of film as an art form. In July 2007, they opened a two-screen cinema.')
    fill_in('pinpoint_description', :with => '<p>Open seven days a week, Film Streams hosts four principal programs:</p><p><strong>FIRST RUN FILMS </strong></p><p>American independents, documentaries, and foreign films making their theatrical premieres in Omaha and the surrounding region. </p><p><strong>REPERTORY SELECTIONS </strong></p><p>Classic films, themed series, and director retrospectives, including contributions from guest curators (Alexander Payne Presents, inAugust 2007 and Fall 2013; Kurt Andersen\'s Out There: Nebraska and the Great Plains in the Movies, November 2007), an ongoing "Great Directors" series (Ingmar Bergman, Federico Fellini, Charlie Chaplin,Orson Welles, John Cassavetes, Stanley Kubrick, Akira Kurosawa,Alfred Hitchcock, Werner Herzog, Preston Sturges & Billy Wilder), and series dedicated to the special guests for our Feature celebrations (Laura Dern, July 2008; Debra Winger, September 2009; Steven Soderbergh, February-March 2011; Jane Fonda, July 2012. The second Alexander Payne series celebrated Feature V).</p>')
    fill_in('hidden_place', :with => 'Film Streams')
    fill_in('map', :with => '<iframe src="https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d2998.975070705499!2d-95.93647947091674!3d41.265878692384256!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sen!2sus!4v1394828387892" width="500" height="500" frameborder="0" style="border:0"></iframe>')
    fill_in('pinpoint_map', :with => '<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2998.9735891656187!2d-95.93418350000002!3d41.26591094999994!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x87938fb6f5189601%3A0xfe7b0d81e1ad8f81!2sFilm+Streams!5e0!3m2!1sen!2sus!4v1394828366490" width="500" height="500" frameborder="0" style="border:0"></iframe>')
    click_button('Submit')
    
    expect(page).to have_content 'The Mynabirds'
    
  end
  
end