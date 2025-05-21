import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PostService {
  private apiUrl = 'http://127.0.0.1:8000/api/posts';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('token');
    return new HttpHeaders({
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    });
  }

  getGroupsByUser(groupId: number): Observable<any> {
    const headers = this.getHeaders();
    return this.http.get(`${this.apiUrl}/getByGroup/${groupId}`, { headers });
  }

  getLastPosts(userId?: number): Observable<any> {
    const headers = this.getHeaders();
    return this.http.get(`${this.apiUrl}/getLastPosts`, { headers });
  }

  createPost(postData: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/create`, postData)
  }

  updatePost(postId: number):Observable<any> {
    const headers = this.getHeaders()
    const newPostData = {
      "title": "Post Caché", 
      "text": "Le contenu de ce post est caché car en vérification par l'un de nos modérateurs",
    }
    return this.http.put(`${this.apiUrl}/update/${postId}`, { newPostData }, { headers })
  }

  deletePost(postId: number):Observable<any> {
    const headers = this.getHeaders()
    return this.http.delete(`${this.apiUrl}/delete/${postId}`, { headers })
  }
}
