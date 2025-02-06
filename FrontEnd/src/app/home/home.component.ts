import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

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
export class HomeComponent {
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

  groups: Group[] = [
    {
      name: 'Les toto du CESI',
      image: 'assets/images/group1.jpg',
      lastActivity: 'Dernière activité il y a 2h'
    },
    {
      name: 'Groupe de travail Crypto',
      image: 'assets/images/group2.jpg',
      lastActivity: 'Dernière activité il y a 3 jours'
    }
  ];
}

export default HomeComponent;