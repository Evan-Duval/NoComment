import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GroupService } from '../services/group.service';

interface Post {
  author: string;
  content: string;
  timestamp: string;
  likes?: number;
  comments?: number;
}

interface Group {
  name: string;
  image: string;
  lastActivity?: string;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  groups: any[] = [];
  userId: number = 1;
  showCreateButton: boolean = false;

  constructor(private groupService: GroupService) {}

  ngOnInit(): void {
    this.groupService.getGroupsByUser(this.userId).subscribe(
      data => {
        this.groups = data;
        this.showCreateButton = this.groups.length === 0;
      },
      error => {
        console.error('Erreur lors de la récupération des groupes', error);
      }
    );
  }
  posts: Post[] = [
    {
      author: 'Anaïs',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque in ante quis magna faucibus tincidunt.',
      timestamp: '2 heures',
      likes: 5,
      comments: 2
    },
    {
      author: 'Émile',
      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
      timestamp: '4 heures',
      likes: 3,
      comments: 1
    }
  ];
}

export default HomeComponent;