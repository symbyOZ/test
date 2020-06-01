package controller

import (
	"html/template"
	"io"
	"net/http"
	"regexp"

	opentracing "github.com/opentracing/opentracing-go"
)

var (
	blogPostController *BlogPostController = new(BlogPostController)
	commentController  *CommentController  = new(CommentController)
)

var (
	Tracer opentracing.Tracer
	Closer io.Closer
)

var (
	postsPath    = regexp.MustCompile(`^(/|/posts)/{0,1}\?*`)
	postPath     = regexp.MustCompile(`^/posts/(\d+)`)
	commentsPath = regexp.MustCompile(`^/posts/(\d+)/comments`)
)

func handleRequest(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		if commentsPath.MatchString(r.URL.Path) {
			commentController.createComment(w, r)
		} else if postsPath.MatchString(r.URL.Path) {
			blogPostController.createBlogPost(w, r)
		}
	case http.MethodPut:
		if postPath.MatchString(r.URL.Path) {
			blogPostController.updateBlogPost(w, r)
		}
	case http.MethodGet:
		if postPath.MatchString(r.URL.Path) {
			blogPostController.showBlogPost(w, r)
		} else if postsPath.MatchString(r.URL.Path) {
			blogPostController.showBlogList(w, r)
		}
	default:
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"error": "Unknown request"}`))
	}
}

func Setup(tc *template.Template) {
	SetTemplateCache(tc)
	createResourceServer()

	http.HandleFunc("/", handleRequest)
}

func createResourceServer() {
	http.Handle("/public/",
		http.StripPrefix("/public",
			http.FileServer(http.Dir("/go/static/public"))))
}

func SetTemplateCache(tc *template.Template) {
	blogPostController.blogListTemplate = tc.Lookup("blogList.html")
	blogPostController.blogTemplate = tc.Lookup("blogEntry.html")
}
