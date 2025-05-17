import { HttpClient } from '@angular/common/http';
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

  getCommentsByPost(postId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getByPost/${postId}`);
  }

  getCommentNumberByPost(postId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getCommentNumberByPost/${postId}`);
  }

  addComment(commentData:Comment): Observable<any> {
    return this.http.post(`${this.apiUrl}/create/`, commentData);
  }
}
