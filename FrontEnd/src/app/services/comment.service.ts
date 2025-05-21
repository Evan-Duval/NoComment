import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

interface Comment {
  text: string;
  id_user: number;
  id_post: number;
  datetime: string;
}

@Injectable({
  providedIn: 'root'
})
export class CommentService {

  private apiUrl = 'http://127.0.0.1:8000/api/comments';
  
  constructor(private http: HttpClient) {}
  
  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('token');
    return new HttpHeaders({
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    });
  }

  getCommentsByPost(postId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getByPost/${postId}`);
  }

  getCommentNumberByPost(postId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getCommentNumberByPost/${postId}`);
  }

  getLastComments(): Observable<any> {
    const headers = this.getHeaders();
    return this.http.get(`${this.apiUrl}/getLastComments/`, { headers });
  }

  addComment(commentData:Comment): Observable<any> {
    return this.http.post(`${this.apiUrl}/create/`, commentData);
  }

  updateComment(commentId: number): Observable<any> {
    const headers = this.getHeaders();
    const newCommentData = {
      "text": "Commentaire caché. Raison : Vérification par un modérateur...",
    }
    return this.http.put(`${this.apiUrl}/update/${commentId}`, newCommentData, { headers });
  }

  deleteComment(commentId: number): Observable<any> {
    const headers = this.getHeaders();
    return this.http.delete(`${this.apiUrl}/delete/${commentId}`, { headers });
  }
}
