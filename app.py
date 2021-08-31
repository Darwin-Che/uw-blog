from pathlib import Path

from flask import Flask, render_template, request, send_from_directory, make_response, url_for

app = Flask(__name__, template_folder='./')

# self defined global variables
html_root_path = str(Path('..', 'content').resolve())
tmpl_root_path = str(Path('..', 'template').resolve())
db = {}  # fields are url, title, summary, prev, next, category

# configuration
config = {
    'sumlen' : 100
}

# init the database for articles

def initdb():
    fh = open('pages.meta', 'r')
    while True:
        line = fh.readline()
        if not line:
            break
        line = line.strip().split()
        if len(line) < 4:
            print('too short line input')
        ftxt = open(f'content/{line[0]}.txt')
        db[line[0]] = {
            'url' : f'notes/{line[0]}',
            'title' : ftxt.readline(),
            'summary' : ftxt.readline()[:config['sumlen']],
            'prev' : None if line[1] == 'NULL' else line[1],
            'next' : None if line[2] == 'NULL' else line[2], 
            'category' : line[3:]
        }
        ftxt.close()
    fh.close()

initdb() 

## helper functions

@app.context_processor
def utility_processor():
    def genurl(id):
        return url_for(f'notes', id=id)
    return dict(genurl=genurl)

@app.route('/home.html')
@app.route('/home')
@app.route('/')
def home():
    nav = render_template('templates/navigation.html')
    print(db['linux-notes']['title'])
    return render_template('templates/lists.html', 
                navbox=nav,
                page='Home Page', 
                title='All Articles',
                atcls=db
                )


@app.route('/notes/<id>')
def notes(id):
    nav = render_template('templates/navigation.html')
    atcltext = render_template(f'content/{id}' if id.endswith('.html') else f'content/{id}.html')
    outline = render_template('templates/outline.html', 
        db=db,
        prev=db[id]["prev"],
        next=db[id]["next"])
        # url_prev=f'notes/{db[id]["prev"]}',
        # title_prev=db[ db[id]["prev"] ]["title"],
        # url_next=f'notes/{db[id]["next"]}',
        # title_next=db[ db[id]["next"] ]["title"])

    return render_template(
        'templates/article.html',
        navbox=nav,
        atcltext=atcltext,
        outline=outline
    )

